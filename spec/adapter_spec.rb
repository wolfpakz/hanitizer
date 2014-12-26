require 'rspec'
require 'hanitizer/adapter'
require 'support/test_adapter'

module Hanitizer

  RSpec.describe Adapter::Test do
    subject(:adapter) { Adapter::Test.new }

    describe '#sanitize_with' do
      it 'creates a cleaner with a formula'
      it 'cleans the repository'
    end
  end
end
