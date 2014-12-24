require 'hanitizer'
require 'hanitizer/formula'

RSpec.describe Hanitizer do
  it 'exists' do
    expect(defined? Hanitizer).to be_truthy
  end

  describe '.formula' do
    let!(:formula) { Hanitizer::Formula.new(formula_name) }
    let(:formula_name) { :foo }

    before do
      allow(Hanitizer::Formula).to receive_messages(:new => formula)
      Hanitizer.formula(formula_name) {}
    end

    it 'creates a new Formula' do
      expect(Hanitizer::Formula).to have_received(:new).with(formula_name)
    end

    it 'adds the Formula to the list of formulae' do
      expect(Hanitizer.formulae[formula_name]).to equal formula
    end

    context 'without a block' do
      it 'raises an ArgumentError' do
        expect {
          Hanitizer.formula(:name)
        }.to raise_error(ArgumentError)
      end
    end

    context 'with a block' do
      let(:definition_block) {
        lambda { |formula|
          truncate :foo
        }
      }

      before do
        allow(formula).to receive_messages(:truncate => true)
        Hanitizer.formula(:foo, &definition_block)
      end

      it 'evaluates the block in the context of the new Formula' do
        expect(formula).to have_received(:truncate).with(:foo)
      end
    end
  end

  describe '.formulae' do
    it 'is enumerable' do
      expect(Hanitizer.formulae).to respond_to :each
    end

    it 'has keys' do
      expect(Hanitizer.formulae).to respond_to :keys
    end
  end
end