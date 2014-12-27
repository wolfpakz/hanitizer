require 'hanitizer/adapter'
require 'hanitizer/adapter/mysql'
require 'support/an_adapter'

module Hanitizer

  class Adapter::MysqlTest < Adapter::Mysql
  end

  RSpec.describe Adapter::Mysql do
    subject(:adapter) { Adapter::MysqlTest.new }

    let(:host)     { 'localhost' }
    let(:database) { 'test' }
    let(:username) { 'user' }
    let(:password) { 'secret' }
    let(:url)      { "mysql2://#{username}:#{password}@#{host}/test" }

    let(:client_double) {
      client = double('Mysql2::Client')

      def client.escape(name)
        name
      end

      client
    }

    let(:result_double) {
      double('Mysql2::Result', each: stubbed_entries, count: stubbed_entries.size)
    }

    let(:stubbed_entries) {
      [
        {:id => 1, :first_name => 'Mr.', :last_name => 'Fantastic'},
        {:id => 2, :first_name => 'Incredible', :last_name => 'Hulk'}
      ]
    }

    let(:collection_name) { 'test_collection' }

    before do
      allow(::Mysql2::Client).to receive_messages(:new => client_double)
      allow(adapter).to receive_messages(:client => client_double)
    end

    it_behaves_like 'an adapter' do
      let!(:adapter) { Adapter::MysqlTest.new }
      let(:collection_name) { database }
      let(:entries) { stubbed_entries }
    end

    describe '#connect' do
      it 'connects to the repository' do
        adapter.connect url
        expect(::Mysql2::Client).to have_received(:new)
      end

      it 'connects to the correct host' do
        expect(::Mysql2::Client).to receive(:new).with(hash_including :host => host)
        adapter.connect url
      end

      it 'connects using a username' do
        expect(::Mysql2::Client).to receive(:new).with(hash_including :username => username)
        adapter.connect url
      end

      it 'connects using a password' do
        expect(::Mysql2::Client).to receive(:new).with(hash_including :password => password)
        adapter.connect url
      end

      it 'connects to the correct database' do
        expect(::Mysql2::Client).to receive(:new).with(hash_including :database => database)
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
        allow(client_double).to receive_messages(:query => result_double)
        adapter.connect url
      end

      it 'reads all entries from the collection' do
        entries = adapter.collection_entries(collection_name)

        expect(entries.count).to eq stubbed_entries.size
      end
    end

    describe '#truncate' do
      before do
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
        allow(client_double).to receive_messages(:query => true)
      end

      it 'updates the identified entry' do
        adapter.update collection_name, id, attributes

        expect(client_double).to have_received(:query).with(/UPDATE #{collection_name} SET/)
        expect(client_double).to have_received(:query).with(/first_name = '#{first_name}'/)
        expect(client_double).to have_received(:query).with(/last_name = '#{last_name}'/)
        expect(client_double).to have_received(:query).with(/WHERE id = #{id}/)
      end

      context 'with an empty hash' do
        let(:attributes) { {} }

        it 'does not update anything' do
          expect(client_double).not_to receive(:query)
          adapter.update collection_name, id, attributes
        end
      end
    end
  end
end