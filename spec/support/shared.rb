shared_context 'stub out everything path' do
  let(:fake_everything_path) do
    '/fake/everything/path'
  end

  before do
    allow(Everything).to receive(:path).and_return(fake_everything_path)
  end
end

shared_context 'with fake piece' do
  include_context 'stub out everything path'

  let(:given_post_name) do
    fake_post_name
  end
  let(:given_piece_path) do
    File.join(Everything.path, given_post_name)
  end
  let(:fake_piece) do
    Everything::Piece.new(given_piece_path)
  end
  let(:fake_post_name) do
    'grond-crawled-on'
  end
  let(:fake_piece_title) do
    'Grond Crawled On'
  end
  let(:fake_piece_body) do
    'Or so I was told.'
  end
  let(:post_options) do
    {}
  end

  before do
    FakeFS.activate!

    FileUtils.mkdir_p(fake_piece.full_path)

    File.open(fake_piece.content.file_path, 'w') do |f|
      f.write("# #{fake_piece_title}\n\n#{fake_piece_body}")
    end

    File.open(fake_piece.metadata.file_path, 'w') do |f|
      f.write("---\npublic: #{post_options[:public?] || false}")
    end
  end

  after do
    FileUtils.rm_rf(given_piece_path)

    FakeFS.deactivate!
  end
end

shared_context 'with deleted piece' do
  before do
    FileUtils.rm_rf(fake_piece.full_path)
  end
end

shared_context 'with deleted metadata file' do
  before do
    File.delete(fake_piece.metadata.file_path)
  end
end

