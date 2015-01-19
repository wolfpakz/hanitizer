require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::Country do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'generates a fake country' do
        expect(Faker::Address).to receive(:country)
        generator.generate(row)
      end
    end
  end
end