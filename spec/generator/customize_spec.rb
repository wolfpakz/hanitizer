require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::Customize do
    subject(:generator) { described_class.new }


    describe '#generate' do
      let(:field) { 'email' }
      let(:value) { 'public.email@example.com' }
      let(:updated_value) { 'foobar'}

      let(:row) {
        {
          :first_name => 'Dynaguy',
          field => value
        }
      }

      let(:block_result) {
        generator.generate(row) {|row| updated_value}
      }

      it 'passes the row to the customize block' do
        row_passed = false
        customize_block = lambda { |incoming_row|
          row_passed = true if incoming_row.eql?(row)
        }
        generator.generate(row, &customize_block)

        expect(row_passed).to eq true
      end

      it 'returns the block result' do
        expect(block_result).to eq updated_value
      end

      context 'without a block' do
        it 'raises an ArgumentError' do
          expect {
            generator.generate(row)
          }.to raise_error ArgumentError
        end
      end
    end
  end
end