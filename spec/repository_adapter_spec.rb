require 'rspec'
require 'hanitizer/repository_adapter'

module Hanitizer

  class RepositoryAdapter::TestAdapter < RepositoryAdapter
  end

  RSpec.describe RepositoryAdapter do
    subject(:adapter) { TestAdapter.new }

    describe '#sanitize_with' do
      it 'creates a new Cleaner'
      it 'cleans the repository'
    end
  end
end
