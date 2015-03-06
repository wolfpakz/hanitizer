require 'rspec'
require 'hanitizer'
require 'hanitizer/adapter'
require 'support/test_adapter'

module Hanitizer

  RSpec.describe Adapter do
    subject(:adapter) { Adapter::Test.new }

    let(:formulas) {
      list = {}
      list[:first]  =  Formula.new(:first)
      list[:second] =  Formula.new(:second)
      list
    }

    before do
      allow(Hanitizer).to receive_messages(:formulas => formulas)
    end

    let!(:cleaner) { Cleaner.new(*formula_list) }
    let(:formula_list) { [formulas[:first], formulas[:second]] }

    describe '#sanitize_with' do
      it 'creates a cleaner with formula(s)' do
        expect(Cleaner).to receive(:new).with(*formula_list).and_return(cleaner)

        adapter.sanitize_with :first, :second
      end

      it 'cleans the repository' do
        allow(Cleaner).to receive(:new).with(*formula_list).and_return(cleaner)
        expect(cleaner).to receive(:clean).with(adapter)

        adapter.sanitize_with :first, :second
      end

      context 'when a formula cannot be found' do
        it 'raises a MissingFormulaError' do
          expect {
            adapter.sanitize_with :floo
          }.to raise_error MissingFormulaError
        end
      end
    end
    
    describe '#symbolize_keys' do
      let(:entry) {
        { 'key' => 'value' }
      }
      
      it 'symolizes string keys' do
        expect(subject.symbolize_keys(entry)).to have_key(:key)
      end
    end
  end
end
