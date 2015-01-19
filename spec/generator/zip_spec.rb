require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::Zip do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'generates a fake zip code' do
        expect(Faker::Address).to receive(:zip)
        generator.generate(row)
      end
    end
  end
end