require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::FirstName do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'generates a fake first name' do
        expect(Faker::Name).to receive(:first_name)
        generator.generate(row)
      end
    end
  end
end