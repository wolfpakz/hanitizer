require 'hanitizer/adapter'
require 'hanitizer/adapter/mysql'

module Hanitizer

  class Adapter::MysqlTest < Adapter::Mysql
  end

  RSpec.describe Adapter::Mysql do
    subject(:adapter) { Adapter::MysqlTest.new }

    let(:host) { 'localhost' }
    let(:database) { 'test' }
    let(:username) { 'user' }
    let(:password) { 'secret' }
    let(:uri) { 'mysql2://localhost/test' }

    let(:client_double) {
      client = double('Mysql2::Client')

      def client.escape(name)
        name
      end

      client
    }

    before do
      allow(::Mysql2::Client).to receive_messages(:new => client_double)
    end

    describe '#connect' do
      it 'connects to the repository' do
        adapter.connect uri
        expect(::Mysql2::Client).to have_received(:new)
      end

      context 'with an invalid URI' do
        let(:uri) { 'crap;://localhost/' }

        it 'raises an error' do
          expect {
            adapter.connect uri
          }.to raise_error(URI::InvalidURIError)
        end
      end
    end

    describe '#collection_entries' do
      let(:stubbed_entries) {
        [
          {:id => 1, :first_name => 'Mr.', :last_name => 'Fantastic'},
          {:id => 2, :first_name => 'Incredible', :last_name => 'Hulk'}
        ]
      }
      
      let(:result_double) {
        double('Mysql2::Result', each: stubbed_entries, count: stubbed_entries.size)
      }

      before do
        allow(client_double).to receive_messages(:query => result_double)
        adapter.connect uri
      end

      it 'reads all entries from the collection' do
        entries = adapter.collection_entries(:test)

        expect(entries.count).to eq stubbed_entries.size
      end
    end

    describe '#truncate' do
      before do
        allow(adapter).to receive_messages(:client => client_double)
        allow(client_double).to receive_messages(:query => true)
      end

      it 'truncates the named collection' do
        adapter.truncate :some_collection
        expect(client_double).to have_received(:query).with('TRUNCATE some_collection')
      end

      context 'with multiple collections' do
        it 'truncates all named collections' do
          adapter.truncate :first, :second

          expect(client_double).to have_received(:query).with('TRUNCATE first')
          expect(client_double).to have_received(:query).with('TRUNCATE second')
        end
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