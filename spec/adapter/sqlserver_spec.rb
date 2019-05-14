require 'hanitizer/adapter'
require 'hanitizer/adapter/sqlserver'
require 'support/an_adapter'

module Hanitizer
  class Adapter::SqlserverTest < Adapter::Sqlserver
    def initialize(reader, writer)
      @reader = reader
      @writer = writer
    end
  end

  RSpec.describe Adapter::Sqlserver do
    subject(:adapter) { Adapter::SqlserverTest.new(reader, writer) }

    let(:host)     { 'localhost' }
    let(:database) { 'hanitizer_test' }
    let(:username) { 'user' }
    let(:password) { 'secret' }
    let(:url)      { "sqlserver://#{username}:#{password}@#{host}/#{database}" }

    let!(:reader) { double('TinyTds::Client') }
    let!(:writer) { double('TinyTds::Client') }

    let(:result_double) { double('TinyTds::Result', each: stubbed_entries, affected_rows: stubbed_entries.size, do: true) }
    let(:stubbed_entries) {
      [
        {:id => 1, :first_name => 'Mr.', :last_name => 'Fantastic'},
        {:id => 2, :first_name => 'Incredible', :last_name => 'Hulk'}
      ]
    }

    let(:collection_name) { 'test_collection' }

    before do
      allow(reader).to receive(:escape) {|str| str }
      allow(writer).to receive(:escape) {|str| str }
    end

    it_behaves_like 'an adapter' do
      let!(:adapter) { Adapter::SqlserverTest.new(reader, writer) }
      let(:collection_name) { database }
      let(:entries) { stubbed_entries }
    end
    
    describe '#connect' do
      before do
        allow(::TinyTds::Client).to receive(:new).exactly(2).times
      end

      it 'connects to the repository twice--one reader connection, one writer connection' do
        adapter.connect url
        expect(::TinyTds::Client).to have_received(:new).exactly(2).times
      end

      it 'connects to the correct host' do
        expect(::TinyTds::Client).to receive(:new).with(hash_including :host => host).exactly(2).times
        adapter.connect url
      end

      it 'connects using a username' do
        expect(::TinyTds::Client).to receive(:new).with(hash_including :username => username).exactly(2).times
        adapter.connect url
      end

      it 'connects using a password' do
        expect(::TinyTds::Client).to receive(:new).with(hash_including :password => password).exactly(2).times
        adapter.connect url
      end

      it 'connects to the correct database' do
        expect(::TinyTds::Client).to receive(:new).with(hash_including :database => database).exactly(2).times
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
        allow(reader).to receive_messages(:execute => result_double)
      end

      it 'reads all entries from the collection' do
        entries = adapter.collection_entries(collection_name)

        expect(entries.count).to eq stubbed_entries.size
      end
    end

    describe '#truncate' do
      before do
        allow(writer).to receive(:execute).and_return(result_double)
      end

      it 'truncates the named collection' do
        adapter.truncate :some_collection

        expect(writer).to have_received(:execute).with('TRUNCATE TABLE some_collection')
      end

      context 'with multiple collections' do
        it 'truncates all named collections' do
          adapter.truncate :first, :second

          expect(writer).to have_received(:execute).with('TRUNCATE TABLE first')
          expect(writer).to have_received(:execute).with('TRUNCATE TABLE second')
        end
      end
    end

    describe '#update' do
      let(:collection_name) { 'the_incredibles' }
      let(:primary_key) { :customPk }
      let(:id) { 1 }
      let(:first_name) { 'Fro' }
      let(:last_name) { 'Zone' }
      let(:attributes) { {:first_name => first_name, :last_name => last_name} }

      before do
        allow(writer).to receive(:execute).and_return(result_double)
      end

      it 'updates the identified entry' do
        adapter.update collection_name, primary_key, id, attributes

        expect(writer).to have_received(:execute).with(/UPDATE #{collection_name} SET/)
        expect(writer).to have_received(:execute).with(/first_name = '#{first_name}'/)
        expect(writer).to have_received(:execute).with(/last_name = '#{last_name}'/)
        expect(writer).to have_received(:execute).with(/WHERE #{primary_key} = #{id}/)
      end

      context 'with an empty hash' do
        let(:attributes) { {} }

        it 'does not update anything' do
          expect(writer).not_to receive(:execute)
          adapter.update collection_name, primary_key, id, attributes
        end
      end

      context 'with null values' do
        let(:attributes) {
          {:first_name => first_name, :last_name => nil}
        }

        it 'sets the field to NULL' do
          expect(writer).to receive(:execute).with(/last_name = NULL/)
          adapter.update collection_name, primary_key, id, attributes
        end
      end

      context 'with fixnum values' do
        let(:attributes) {
          {:first_name => first_name, :age => 12}
        }

        it 'sets the field value correctly' do
          expect(writer).to receive(:execute).with(/age = 12/)
          adapter.update collection_name, primary_key, id, attributes
        end
      end
    end
  end
end