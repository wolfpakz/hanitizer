require 'rspec'
require 'hanitizer/formula'

module Hanitizer
  RSpec.describe Formula do
    subject(:formula) { Formula.new name }

    let(:name) { :elastic_girl }

    # it do
    #   # Define some formulas
    #   formula_a = Formula.new :some_name
    #   formula_a.truncate :batches, :entries, :headers, :files, :transactions
    #
    #   formula_b = Formula.new :some_name
    #   formula_b.truncate :batches, :entries, :headers, :files, :transactions
    #
    #   # Apply the formula
    #   cleaner = Cleaner.new formula_a, formula_b
    #   cleaner.clean repository
    # end

    it 'has a name' do
      expect(formula).to respond_to :name
    end

    it 'has truncations' do
      expect(formula).to respond_to :truncations
    end

    it 'has sanitizers' do
      expect(formula).to respond_to :sanitizers
    end

    describe '.new' do
      let(:name) { :mr_incredible }

      it 'sets the name' do
        expect(formula.name).to eq name
      end
    end

    describe '#sanitize' do
      let(:collection) { :hunters }
      let(:example_block) {
        lambda {
          formula.sanitize collection do
            email :email
          end
        }
      }

      it 'adds the named collection to #sanitizers' do
        expect(example_block).to change { formula.sanitizers.keys.include?(collection.to_s) }.from(false).to(true)
      end

      it 'adds to the #sanitizers hash' do
        expect(example_block).to change { formula.sanitizers.values.size }.by(1)
      end

      context 'with a repeated collection name' do
        before do
          example_block.call
        end

        it 'does not add to #collections' do
          expect(example_block).not_to change { formula.sanitizers.keys.size }
        end
      end
    end

    describe '#santizers' do
      it 'has keys' do
        expect(formula.sanitizers).to respond_to :keys
      end
    end

    describe '#truncate' do
      let(:name) { :foobar }

      before do
        formula.truncate name
      end

      it 'adds a truncation' do
        expect(formula.truncations).to include(name.to_s)
      end

      context 'with a duplicate name' do
        let(:duplicate) { :dup }

        before do
          formula.truncate duplicate
        end

        it 'does not add the duplicate' do
          expect {
            formula.truncate duplicate
          }.not_to change { formula.truncations.size }.from(formula.truncations.size)
        end
      end
    end

    describe '#truncations' do
      it 'is enumerable' do
        expect(formula.truncations).to respond_to :each
      end
    end
  end
end
