require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::Nullify do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:row) { Hash.new }

      it 'returns nil' do
        expect(generator.generate row).to be_nil
      end
    end
  end
end