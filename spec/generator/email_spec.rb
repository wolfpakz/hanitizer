require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::Email do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'generates a fake email address' do
        expect(Faker::Internet).to receive(:safe_email)
        generator.generate(row)
      end
    end
  end
end