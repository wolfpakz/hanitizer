require 'hanitizer/generator'

module Hanitizer
  describe Generator::Context do
    subject(:context) { described_class.new row }

    let(:row) {
      {
        :first_name => 'Dynaguy'
      }
    }

    it 'has a row' do
      expect(context).to respond_to :row
    end

    describe '#apply_generator' do
      let(:name)  { 'address1' }
      let(:field) { 'street_address' }
      let(:value) { '1 Lost Lane' }
      let(:generator) {
        double('Generator::' + Inflector.pascalize(name), :generate => value)
      }

      before do
        context.apply_generator(generator, field)
      end

      it 'sets the named field' do
        expect(row[field]).to_not be_nil
      end

      it 'updates the named field' do
        expect(row[field]).to eq value
      end
    end

    describe '#execute' do
      let(:definition) {
        lambda {
          'HUNT'
        }
      }
      let(:field)  { :name }
      let(:result) { context.execute(&definition) }

      it 'binds the definition and executes it' do
        result = false

        test_context = context
        definition = lambda { |row|
          result = true if self.eql?(test_context)
        }

        expect {
          context.execute(&definition)
        }.to change { result }.from(false).to(true)
      end

      it 'passes the row when executing the definition' do
        row_passed = false
        definition = lambda { |incoming_row|
          row_passed = true if incoming_row.eql?(row)
        }

        expect {
          context.execute(&definition)
        }.to change { row_passed }.from(false).to(true)
      end

      it 'returns the row' do
        expect(context.execute(&definition)).to equal row
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
      end

      shared_examples_for 'creating the correct generator' do
        it 'creates the correct generator' do
          expect(klass).to receive(:new).and_call_original
          context.execute(&definition)
        end

        it 'applies the generator' do
          generator = klass.new
          allow(klass).to receive(:new).and_return(generator)

          expect(context).to receive(:apply_generator).with(generator, field)
          context.execute(&definition)
        end
      end

      context 'with #first_name in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :first_name }
          let(:klass) { Generator::FirstName }
          let(:definition) {
            field_name = field
            lambda { first_name field_name }
          }
        end
      end

      context 'with #last_name in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :last_name }
          let(:klass) { Generator::LastName }
          let(:definition) {
            field_name = field
            lambda { last_name field_name }
          }
        end
      end

      context 'with #email in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :email }
          let(:klass) { Generator::Email }
          let(:definition) {
            field_name = field
            lambda { email field_name }
          }
        end
      end

      context 'with #address1 in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :address1 }
          let(:klass) { Generator::Address1 }
          let(:definition) {
            field_name = field
            lambda { address1 field_name }
          }
        end
      end

      context 'with #address2 in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :address2 }
          let(:klass) { Generator::Address2 }
          let(:definition) {
            field_name = field
            lambda { address2 field_name }
          }
        end
      end

      context 'with #city in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :city }
          let(:klass) { Generator::City }
          let(:definition) {
            field_name = field
            lambda { city field_name }
          }
        end
      end

      context 'with #state in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :state }
          let(:klass) { Generator::State }
          let(:definition) {
            field_name = field
            lambda { state field_name }
          }
        end
      end

      context 'with #zip in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :zip }
          let(:klass) { Generator::Zip }
          let(:definition) {
            field_name = field
            lambda { zip field_name }
          }
        end
      end

      context 'with #country in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :country }
          let(:klass) { Generator::Country }
          let(:definition) {
            field_name = field
            lambda { country field_name }
          }
        end
      end

      context 'with #nullify in the definition' do
        let(:field) { 'transaction_code' }
        let(:value) { 'secret_code' }

        let(:definition) {
          field_name = field
          lambda { |row|
            nullify field_name
          }
        }

        let(:row) {
          {
            :first_name => 'Dynaguy',
            field => value
          }
        }

        it_behaves_like 'creating the correct generator' do
          let(:name)  { :nullify }
          let(:klass) { Generator::Nullify }
          let(:definition) {
            field_name = field
            lambda { nullify field_name }
          }
        end
      end

      context 'with #customize in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :customize }
          let(:klass) { Generator::Customize }
          let(:definition) {
            field_name = field
            lambda {
              customize(field_name) do
                'foo'
              end
            }
          }
        end
      end

      context 'with #marshal in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :marshal }
          let(:klass) { Generator::Marshal }
          let(:definition) {
            field_name = field
            lambda {
              marshal(field_name) do
                'foo'
              end
            }
          }
        end
      end

      context 'with #unmarshal in the definition' do
        it_behaves_like 'creating the correct generator' do
          let(:name)  { :unmarshal }
          let(:klass) { Generator::Unmarshal }
          let(:definition) {
            field_name = field
            lambda {
              unmarshal(field_name) do
                'foo'
              end
            }
          }
          let(:row) {
            h = {:first_name => 'Dynaguy' }
            h[field] = Marshal.dump 'abc'
            h
          }
        end
      end
    end
  end
end