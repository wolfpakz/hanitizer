require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::Address2 do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'generates a fake address (line2)' do
        expect(Faker::Address).to receive(:secondary_address)
        generator.generate(row)
      end
    end
  end
end