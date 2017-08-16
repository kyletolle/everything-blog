shared_context 'stub out everything path' do
  let(:fake_everything_path) do
    '/fake/everything/path'
  end

  before do
    allow(Everything).to receive(:path).and_return(fake_everything_path)
  end
end

shared_context 'create blog path' do
  before do
    FileUtils.mkdir_p(Everything::Blog::Source.absolute_path)
  end
end

shared_context 'with fakefs' do
  before do
    FakeFS.activate!
  end

  after do
    FakeFS.deactivate!
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

shared_context 'stub out blog output path' do
  let(:fake_blog_output_path) do
    '/fake/blog/output'
  end
  let(:expected_absolute_path) do
    fake_blog_output_path
  end

  before do
    without_partial_double_verification do
      allow(Fastenv)
        .to receive(:blog_output_path)
        .and_return(fake_blog_output_path)
    end
  end
end

shared_context 'with an index template' do
  let(:index_template_file_path) do
    Everything::Blog::Output::IndexTemplate.new('').template_path
  end

  before do
    FakeFS::FileSystem.clone(index_template_file_path)
  end
end

shared_examples 'raises an error for index template not existing' do
  it 'raises an error for the index template not existing' do
    expect{index.save_file}.to raise_error(Errno::ENOENT, /No such file/)
  end
end

