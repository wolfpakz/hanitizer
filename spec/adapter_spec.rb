require 'rspec'
require 'hanitizer/adapter'
require 'support/test_adapter'

module Hanitizer

  RSpec.describe Adapter::Test do
    subject(:adapter) { Adapter::Test.new }

    # describe '#connect' do
    #   it 'connects to the repository'
    #
    #   context 'with an invalid URI' do
    #     it 'raises an error'
    #   end
    # end
    #
    # describe '#collection_entries' do
    #   it 'reads all entries from the collection'
    # end

    describe '#sanitize_with' do
      it 'creates a new Cleaner'
      it 'cleans the repository'
    end

    describe '#truncate' do
      it 'truncates the named collection'

      context 'with multiple collections' do
        it 'truncates all named collections'
      end
    end

    describe '#update_each' do
      # def update_each(collection_name)
      #   collection_entries(collection_name).each do |entry|
      #     original_hash = entry.to_hash
      #     updated_hash = yield original_hash
      #     update(entry.id, updated_hash) unless updated_hash.eql?(original_hash)
      #   end
      # end

      it 'reads collection entries'
      it 'runs the block on every entry'
      it 'updates the entry with the blocks return value'

      context 'with no block' do
        it 'raises an ArgumentError'
      end
    end

    describe '#update' do
      it 'updates the identified entry'

      context 'without an id' do
        it 'raises an ArgumentError'
      end

      context 'with an empty hash' do
        it 'does not update anything'
      end
    end
  end
end
