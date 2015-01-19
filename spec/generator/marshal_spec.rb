require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::Marshal do
    subject(:generator) { described_class.new }

    describe '#generate' do
      let(:field) { 'email' }
      let(:value) { 'public.email@example.com' }

      let(:row) {
        {
          :first_name => 'Dynaguy',
          field => value
        }
      }

      let(:block_result) {
        generator.generate(row) {|row| value}
      }
      let(:marshaled_value) { Marshal.dump(value) }

      it 'passes the row to the marshal block' do
        row_passed = false
        block = lambda { |incoming_row|
          row_passed = true if incoming_row.eql?(row)
        }
        generator.generate(row, &block)

        expect(row_passed).to eq true
      end

      it 'marshals and returns the block return value' do
        expect(block_result).to eq marshaled_value
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