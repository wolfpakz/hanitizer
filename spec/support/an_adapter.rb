shared_examples_for 'an adapter' do
  it { is_expected.to respond_to :connect }
  it { is_expected.to respond_to :collection_entries }
  it { is_expected.to respond_to :truncate }
  it { is_expected.to respond_to :update }
  it { is_expected.to respond_to :update_each }
end