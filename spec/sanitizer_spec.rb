require 'hanitizer/sanitizer'

module Hanitizer
  RSpec.describe Sanitizer do
    subject(:sanitizer) { Sanitizer.new(&definition) }

    let(:definition) {
      lambda {
        'HUNT'
      }
    }

    let(:row) {
      {
        :first_name => 'Dynaguy'
      }
    }

    it 'has a definition' do
      expect(sanitizer).to respond_to :definition
    end

    describe '.new' do
      let(:definition) {
        lambda {
          'SMASH'
        }
      }

      it 'sets the definition' do
        expect(sanitizer.definition).to equal definition
      end

      context 'without a block' do
        it 'raises an ArgumentError' do
          expect {
            Sanitizer.new :hulk
          }.to raise_error(ArgumentError)
        end
      end
    end

    describe '.sanitize' do
      it 'applies the definition to the row' do
        definition_applied = false

        sanitizer.definition = lambda { |row|
          definition_applied = true
        }

        expect {
          sanitizer.sanitize(row)
        }.to change { definition_applied }.from(false).to(true)

        expect(definition_applied).to eq true
      end

      shared_examples_for 'a basic generator' do |field,value|
        raise ArgumentError, 'Block requires both field and value parameters' unless value

        let(:definition) {
          lambda { |row|
            send(field, field)
          }
        }

        let(:row) {
          {
            :first_name => 'Dynaguy',
            field => value
          }
        }

        let(:constant) { Generator.klass_for(field) }

        let("row_with_#{field}".to_sym) { row }
        let(:result) { sanitizer.sanitize(send "row_with_#{field}".to_sym) }

        display_name = field.to_s.gsub('_', ' ')

        it "creates a #{display_name} generator" do
          expect(constant).to receive(:new).and_call_original
          result
        end

        it 'sets the named field' do
          expect(result[field]).to_not be_nil
        end

        it 'updates the named field' do
          expect(result[field]).to_not eq value
        end
      end

      context 'with #first_name in the definition' do
        it_behaves_like 'a basic generator', :first_name, 'Violet'
      end

      context 'with #last_name in the definition' do
        it_behaves_like 'a basic generator', :last_name, 'Parr'
      end

      context 'with #email in the definition' do
        it_behaves_like 'a basic generator', :email, 'vparr@example.com'
      end

      context 'with #address1 in the definition' do
        it_behaves_like 'a basic generator', :address1, '1 Way Street'
      end

      context 'with #address2 in the definition' do
        it_behaves_like 'a basic generator', :address2, 'Apt 21'
      end

      context 'with #city in the definition' do
        it_behaves_like 'a basic generator', :city, 'Nowhere'
      end

      context 'with #state in the definition' do
        it_behaves_like 'a basic generator', :state, 'DC'
      end

      context 'with #zip in the definition' do
        it_behaves_like 'a basic generator', :zip, '00001'
      end

      context 'with #country in the definition' do
        it_behaves_like 'a basic generator', :country, 'United States'
      end

      context 'with #nullify in the definition' do
        it 'updates the named field to nil'
      end

      context 'with #customize in the definition' do
        it 'passes the row to the customize block'
        it 'updates the named field with the returned value'
      end

      context 'with #marshal in the definition' do
        it 'passes the row to the marshal block'
        it 'marshals the returned value'
        it 'updates the named field with the marshaled value'
      end

      context 'with #unmarshal in the definition' do
        it 'unmarshals the named field from the row'
        it 'passes the unmarshaled value to the block'
        it 'marshals the returned value'
        it 'updates the named field with the marshaled value'
      end
    end
  end
end