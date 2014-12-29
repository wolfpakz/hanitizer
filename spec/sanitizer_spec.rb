require 'hanitizer/sanitizer'

module Hanitizer
  RSpec.describe Sanitizer do
    subject(:sanitizer) { Sanitizer.new(collection, &definition) }

    let(:collection) { :rambo }
    let(:definition) {
      lambda {
        'HUNT'
      }
    }

    it 'exists' do
      expect(defined? Sanitizer).to be_truthy
    end

    it 'has a collection' do
      expect(sanitizer).to respond_to :collection
    end

    it 'has a definition' do
      expect(sanitizer).to respond_to :definition
    end

    describe '.new' do
      let(:collection) { :incredible_hulk }
      let(:definition) {
        lambda {
          'SMASH'
        }
      }

      it 'sets the collection' do
        expect(sanitizer.collection).to eq collection
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