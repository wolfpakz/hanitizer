require 'hanitizer/sanitizer'

module Hanitizer
  RSpec.describe Sanitizer do
    subject(:sanitizer) { Sanitizer.new(&definition) }

    let(:definition) {
      lambda {
        'HUNT'
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
      it 'applies the definition block to the row'

      context 'with #first_name called in the definition' do
        it 'generates a first name'
        it 'updates the named field'
      end

      context 'with #last_name called in the definition' do
        it 'generates a last name'
        it 'updates the named field'
      end

      context 'with #address1 called in the definition' do
        it 'generates an address1'
        it 'updates the named field'
      end

      context 'with #address2 called in the definition' do
        it 'generates an address2'
        it 'updates the named field'
      end

      context 'with #city called in the definition' do
        it 'generates an city'
        it 'updates the named field'
      end

      context 'with #state called in the definition' do
        it 'generates an state'
        it 'updates the named field'
      end

      context 'with #zip called in the definition' do
        it 'generates an zip'
        it 'updates the named field'
      end

      context 'with #country called in the definition' do
        it 'generates an country'
        it 'updates the named field'
      end

      context 'with #nullify called in the definition' do
        it 'updates the named field to nil'
      end

      context 'with #email called in the definition' do
        it 'generates an email'
        it 'updates the named field'
      end

      context 'with #customize called in the definition' do
        it 'passes the row to the customize block'
        it 'updates the named field with the returned value'
      end

      context 'with #marshal called in the definition' do
        it 'passes the row to the marshal block'
        it 'marshals the returned value'
        it 'updates the named field with the marshaled value'
      end

      context 'with #unmarshal called in the definition' do
        it 'unmarshals the named field from the row'
        it 'passes the unmarshaled value to the block'
        it 'marshals the returned value'
        it 'updates the named field with the marshaled value'
      end
    end
  end
end