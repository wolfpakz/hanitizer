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
      let(:context_double) { double('Generator::Context') }

      it 'creates a generator context' do
        expect(Generator::Context).to receive(:new).with(row).and_call_original
        sanitizer.sanitize(row)
      end

      it 'uses the context to execute the definition' do
        definition_applied = false

        sanitizer.definition = lambda { |row|
          definition_applied = true
        }

        expect {
          sanitizer.sanitize(row)
        }.to change { definition_applied }.from(false).to(true)

        expect(definition_applied).to eq true

      end
    end
  end
end