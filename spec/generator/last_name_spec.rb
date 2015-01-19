require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::LastName do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'generates a fake last name' do
        expect(Faker::Name).to receive(:last_name)
        generator.generate(row)
      end
    end
  end
end