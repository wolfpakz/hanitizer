require 'rspec'
require 'hanitizer/formula'

RSpec.describe Formula do
  subject(:formula) { Formula.new }

  it 'has a list of specs' do
    expect(formula).to respond_to :specs
  end

  describe '#clean' do
    it 'exists' do
      expect(formula).to respond_to :clean
    end
  end
end