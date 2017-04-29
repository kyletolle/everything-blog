shared_context 'stub out everything path' do
  let(:fake_everything_path) do
    '/fake/everything/path'
  end

  before do
    allow(Everything).to receive(:path).and_return(fake_everything_path)
  end
end
