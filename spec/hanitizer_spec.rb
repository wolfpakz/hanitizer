require 'hanitizer'
require 'hanitizer/adapter'
require 'hanitizer/formula'
require 'support/test_adapter'

RSpec.describe Hanitizer do
  it 'exists' do
    expect(defined? Hanitizer).to be_truthy
  end

  describe '.adapter_class' do
    let(:arg) { 'test' }

    def result
      Hanitizer.adapter_class arg
    end

    it 'returns the class constant Hanitizer::Adapter::<capitalized string>' do
      expect(result).to equal ::Hanitizer::Adapter::Test
    end

    context 'with a symbol' do
      let(:arg) { :test }

      it 'converts the symbol to a string' do
        expect(result).to equal ::Hanitizer::Adapter::Test
      end
    end

    context 'with upper cased letters' do
      let(:arg) { 'TEST' }

      it 'downcases the name' do
        expect(result).to equal ::Hanitizer::Adapter::Test
      end
    end
  end

  describe '.connect' do
    let(:scheme) { 'test' }
    let(:url) { "#{scheme}://host/" }
    let!(:parsed_url) { URI.parse url }
    let!(:test_adapter) { Hanitizer::Adapter::Test.new }

    it 'takes a database url' do
      expect {
        Hanitizer.connect
      }.to raise_error(ArgumentError)
    end

    it 'parses a database url' do
      expect(::URI).to receive(:parse).with(url).and_return(parsed_url)
      Hanitizer.connect url
    end

    it 'finds the database adapter class' do
      expect(Hanitizer).to receive(:adapter_class).with(scheme).and_return(Hanitizer::Adapter::Test)
      Hanitizer.connect url
    end

    it 'makes a new database adapter' do
      expect(Hanitizer::Adapter::Test).to receive(:new).and_return(test_adapter)
      Hanitizer.connect url
    end

    it 'connects to the database' do
      allow(Hanitizer::Adapter::Test).to receive_messages(:new => test_adapter)

      expect(test_adapter).to receive(:connect)
      Hanitizer.connect url
    end
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