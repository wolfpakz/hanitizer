require 'hanitizer/generator'

module Hanitizer
  RSpec.describe Generator::Unmarshal do
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

      let(:appended_value)  { 'weee!' }
      let(:marshaled_value) { Marshal.dump(value) }

      let(:block_arg) {
        val = appended_value
        lambda {|o| o + val }
      }

      let(:block_result) {
        generator.generate(row, marshaled_value, &block_arg)
      }

      it 'unmarshals the named field from the row' do
        expect(Marshal).to receive(:load).with(marshaled_value).and_call_original
        block_result
      end

      it 'passes the unmarshaled value to the block' do
        value_passed = false
        block = lambda { |incoming|
          value_passed = true if incoming.eql?(value)
        }
        generator.generate(row, marshaled_value, &block)

        expect(value_passed).to eq true
      end

      it 'marshals and returns the block return value' do
        expect(block_result).to eq Marshal.dump(value + appended_value)
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