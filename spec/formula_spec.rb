require 'rspec'
require 'hanitizer/formula'

module Hanitizer
  RSpec.describe Formula do
    subject(:formula) { Formula.new name }

    let(:name) { :elastic_girl }

    # it do
    #   # Define some formulae
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
      it 'creates a new Sanitizer'

      it 'adds a Sanitizer' do
        expect {
          formula.sanitize :rambo do
            email :email
          end
        }.to change { formula.sanitizers.size }.by(1)
      end
    end

    describe '#santizers' do
      it 'is enumerable' do
        expect(formula.sanitizers).to respond_to :each
      end
    end

    describe '#truncate' do
      let(:name) { :foobar }

      before do
        formula.truncate name
      end

      it 'adds a truncation' do
        expect(formula.truncations).to include(:foobar)
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
