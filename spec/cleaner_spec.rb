require 'hanitizer/cleaner'
require 'support/test_adapter'

module Hanitizer
  RSpec.describe Cleaner do
    subject(:cleaner) { Cleaner.new(*formula_list) }
    let(:adapter) { Adapter::Test.new }
    let(:formula_list) { [] }


    describe '.new' do
      let(:formula_list) { [:first] }

      context 'with one formula name' do
        it 'adds to the list of formulas' do
          expect(cleaner.formulas.length).to eq 1
        end
      end

      context 'with multiple formula names' do
        let(:formula_list) { [:first, :second, :third] }

        it 'adds all names to the list of formulas' do
          expect(cleaner.formulas.length).to eq formula_list.length
        end
      end
    end


    describe '#clean' do
      let(:formula_list) { [:one, :two, :three] }

      it 'applies all formulas' do
        expect(cleaner).to receive(:apply).exactly(formula_list.length).times
        cleaner.clean adapter
      end
    end


    describe '#apply' do
      let(:collection_name) { :foo }
      let!(:formula) {
        Formula.new(:test).tap do |f|
          f.truncate :a
          f.truncate :b
          f.truncate :c

          f.sanitize collection_name do |row|
            true
          end
        end
      }

      let(:stubbed_entries) {
        [
          {:id => 4, :first_name => 'Amazing', :last_name => 'Flash'},
          {:id => 5, :first_name => 'Gazer', :last_name => 'Beam'}
        ]
      }

      before do
        allow(adapter).to receive(:collection_entries).and_return(stubbed_entries)
      end

      it 'applies all truncations' do
        formula.truncations.each do |name|
          expect(adapter).to receive(:truncate).with(name)
        end

        cleaner.apply(formula, adapter)
      end

      it 'applies all sanitizers' do
        formula.sanitizers.values do |sanitizer|
          expect(sanitizer).to receive(:sanitize).exactly(stubbed_entries.length).times
        end

        cleaner.apply(formula, adapter)
      end
    end
  end
end
