require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::State do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'generates a fake state' do
        expect(Faker::Address).to receive(:state)
        generator.generate(row)
      end
    end
  end
end