require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::City do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'generates a fake city' do
        expect(Faker::Address).to receive(:city)
        generator.generate(row)
      end
    end
  end
end