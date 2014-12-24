require 'hanitizer/sanitizer'

module Hanitizer
  RSpec.describe Sanitizer do
    subject(:sanitizer) { Sanitizer.new(name, &definition) }

    let(:name) { :rambo }
    let(:definition) {
      lambda {
        'HUNT'
      }
    }

    it 'exists' do
      expect(defined? Sanitizer).to be_truthy
    end

    it 'has a name' do
      expect(sanitizer).to respond_to :name
    end

    it 'has a definition' do
      expect(sanitizer).to respond_to :definition
    end

    describe '.new' do
      let(:name) { :incredible_hulk }
      let(:definition) {
        lambda {
          'SMASH'
        }
      }

      it 'sets the name' do
        expect(sanitizer.name).to eq name
      end

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
  end
end