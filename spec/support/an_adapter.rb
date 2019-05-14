shared_examples_for 'an adapter' do
  it { is_expected.to respond_to :connect }
  it { is_expected.to respond_to :collection_entries }
  it { is_expected.to respond_to :truncate }
  it { is_expected.to respond_to :update }
  it { is_expected.to respond_to :update_each }

  describe '#update_each' do
    before do
      allow(adapter).to receive_messages(:collection_entries => entries)
    end

    it 'reads collection entries' do
      expect(adapter).to receive(:collection_entries).with(collection_name)
      adapter.update_each(collection_name, :id) {|row| {} }
    end

    it 'runs the block on every entry' do
      block_call_count = 0

      adapter.update_each(collection_name, :id) { |row|
        block_call_count += 1
        {}
      }

      expect(block_call_count).to eq entries.size
    end

    context 'when the block returns a new hash' do
      it 'updates the repository' do
        expect(adapter).to receive(:update).exactly(entries.size).times

        index = 0
        adapter.update_each(collection_name, :id) { |row|
          index += 1
          { :first_name => 'Under', :last_name => "Miner #{index}", :quote => 'All will tremble before me!' }
        }
      end
    end

    context 'when the block modifies the original hash' do
      it 'updates the repository' do
        expect(adapter).to receive(:update).exactly(entries.size).times

        index = 0
        adapter.update_each(collection_name, :id) { |row|
          index += 1
          row['first_name'] = '%s %d' % [row['first_name'], index]
          row['last_name']  = '%s %d' % [row['last_name'], index]
          row
        }
      end
    end

    context 'with no block' do
      it 'raises a LocalJumpError' do
        expect {
          adapter.update_each(collection_name, :id)
        }.to raise_error(LocalJumpError)
      end
    end
  end

end