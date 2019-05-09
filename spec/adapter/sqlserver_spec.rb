require 'hanitizer/adapter'
require 'hanitizer/adapter/sqlserver'
require 'support/an_adapter'

module Hanitizer
  class Adapter::SqlserverTest < Adapter::Sqlserver
  end

  RSpec.describe Adapter::Sqlserver do
    subject(:adapter) { Adapter::SqlserverTest.new }
    let(:host)     { 'localhost' }
    let(:database) { 'hanitizer_test' }
    let(:username) { 'user' }
    let(:password) { 'secret' }
    let(:url)      { "sqlserver://#{username}:#{password}@#{host}/#{database}" }

    let!(:client) { TinyTds::Client.new username: 'sa', password: 'P@ssw0rd', host: host }
    let(:result_double) { double('TinyTds::Result', each: stubbed_entries, affected_rows: stubbed_entries.size) }
    
    let(:stubbed_entries) {
      [
        {:id => 1, :first_name => 'Mr.', :last_name => 'Fantastic'},
        {:id => 2, :first_name => 'Incredible', :last_name => 'Hulk'}
      ]
    }

    let(:collection_name) { 'test_collection' }

    before do
      allow(::TinyTds::Client).to receive_messages(:new => client)
      allow(adapter).to receive_messages(:client => client)
    end
    
    it_behaves_like 'an adapter' do
      let!(:adapter) { Adapter::SqlserverTest.new }
      let(:collection_name) { database }
      let(:entries) { stubbed_entries }
    end
    
    describe '#connect' do
      it 'connects to the repository' do
        adapter.connect url
        expect(::TinyTds::Client).to have_received(:new)
      end

      it 'connects to the correct host' do
        expect(::TinyTds::Client).to receive(:new).with(hash_including :host => host)
        adapter.connect url
      end

      it 'connects using a username' do
        expect(::TinyTds::Client).to receive(:new).with(hash_including :username => username)
        adapter.connect url
      end

      it 'connects using a password' do
        expect(::TinyTds::Client).to receive(:new).with(hash_including :password => password)
        adapter.connect url
      end

      it 'connects to the correct database' do
        expect(::TinyTds::Client).to receive(:new).with(hash_including :database => database)
        adapter.connect url
      end

      context 'with an invalid URL' do
        let(:url) { 'crap;://localhost/' }

        it 'raises an error' do
          expect {
            adapter.connect url
          }.to raise_error(URI::InvalidURIError)
        end
      end
    end

    describe '#collection_entries' do
      before do
        allow(client).to receive_messages(:execute => result_double)
        adapter.connect url
      end

      it 'reads all entries from the collection' do
        entries = adapter.collection_entries(collection_name)

        expect(entries.count).to eq stubbed_entries.size
      end
    end

    describe '#truncate' do
      before do
        allow(client).to receive_messages(:execute => true)
      end

      it 'truncates the named collection' do
        adapter.truncate :some_collection

        expect(client).to have_received(:execute).with('TRUNCATE TABLE some_collection')
      end

      context 'with multiple collections' do
        it 'truncates all named collections' do
          adapter.truncate :first, :second

          expect(client).to have_received(:execute).with('TRUNCATE TABLE first')
          expect(client).to have_received(:execute).with('TRUNCATE TABLE second')
        end
      end
    end

    describe '#update' do
      let(:collection_name) { 'the_incredibles' }
      let(:id) { 1 }
      let(:first_name) { 'Fro' }
      let(:last_name) { 'Zone' }
      let(:attributes) { {:first_name => first_name, :last_name => last_name} }

      let(:update_sql) {
        'UPDATE %s SET %s = %s, %s = %s WHERE id = %d' % [collection_name, 'first_']
      }

      before do
        allow(client).to receive_messages(:execute => true)
      end

      it 'updates the identified entry' do
        adapter.update collection_name, id, attributes

        expect(client).to have_received(:execute).with(/UPDATE #{collection_name} SET/)
        expect(client).to have_received(:execute).with(/first_name = '#{first_name}'/)
        expect(client).to have_received(:execute).with(/last_name = '#{last_name}'/)
        expect(client).to have_received(:execute).with(/WHERE id = #{id}/)
      end

      context 'with an empty hash' do
        let(:attributes) { {} }

        it 'does not update anything' do
          expect(client).not_to receive(:execute)
          adapter.update collection_name, id, attributes
        end
      end

      context 'with null values' do
        let(:attributes) {
          {:first_name => first_name, :last_name => nil}
        }

        it 'sets the field to NULL' do
          expect(client).to receive(:execute).with(/last_name = NULL/)
          adapter.update collection_name, id, attributes
        end
      end

      context 'with fixnum values' do
        let(:attributes) {
          {:first_name => first_name, :age => 12}
        }

        it 'sets the field value correctly' do
          expect(client).to receive(:execute).with(/age = 12/)
          adapter.update collection_name, id, attributes
        end
      end
    end
  end
end