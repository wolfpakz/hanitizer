require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::Address1 do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'generates a fake address (line1)' do
        expect(Faker::Address).to receive(:street_address)
        generator.generate(row)
      end
    end
  end
end