require 'fakefs/spec_helpers'

shared_context 'stub out everything path' do
  let(:fake_everything_path) do
    '/fake/everything/path'
  end

  before do
    without_partial_double_verification do
      allow(Fastenv)
        .to receive(:everything_path)
        .and_return(fake_everything_path)
    end
  end
end

shared_context 'stub out templates path' do
  let(:fake_templates_path) do
    '/fake/templates/path'
  end

  before do
    without_partial_double_verification do
      allow(Fastenv)
        .to receive(:templates_path)
        .and_return(fake_templates_path)
    end

  end
end

shared_context 'with fake templates' do
  include_context 'stub out templates path'
  include_context 'with fakefs'

  let(:fake_index_template) do
    Everything::Blog::Output::IndexTemplate.new('')
  end
  let(:fake_post_template) do
    Everything::Blog::Output::PostTemplate.new('')
  end
  let(:fake_template_html) do
    <<~HTML
    <html lang="en">
    <body>
          <%= yield %>
    </body>
    </html>
    HTML
  end

  before do
    FileUtils.mkdir_p(fake_templates_path)

    fake_index_template.template_path.write(fake_template_html)
    fake_post_template.template_path.write(fake_template_html)
  end

  after do
    FileUtils.rm_rf(fake_templates_path)
  end
end

shared_context 'create blog path' do
  before do
    FileUtils.mkdir_p(Everything::Blog::Source.absolute_path)
  end
end

shared_context 'with fakefs' do
  include FakeFS::SpecHelpers

  before do
    FakeFS.activate!
  end

  after do
    FakeFS.deactivate!
  end
end

shared_context 'with fake piece' do
  include_context 'stub out everything path'
  include_context 'with fakefs'

  let(:given_post_name) do
    fake_post_name
  end
  let(:given_piece_path) do
    Everything.path.join(given_post_name)
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
    FileUtils.mkdir_p(fake_piece.absolute_dir)

    fake_piece.absolute_path.write("# #{fake_piece_title}\n\n#{fake_piece_body}")

      public_metadata = "public: #{post_options[:public?] || false}"
      now_iso8601 = Time.now.strftime('%Y-%m-%d')
      created_on_metadata = "created_on: #{post_options[:created_on] || now_iso8601}"
      fake_piece.metadata.absolute_path.write("---\n#{public_metadata}\n#{created_on_metadata}")
  end

  after do
    FileUtils.rm_rf(given_piece_path)
  end
end

shared_context 'with deleted piece' do
  before do
    FileUtils.rm_rf(fake_piece.absolute_dir)
  end
end

shared_context 'with deleted metadata file' do
  before do
    File.delete(fake_piece.metadata.absolute_path)
  end
end

shared_context 'stub out blog output path' do
  let(:fake_blog_output_path) do
    '/fake/blog/output'
  end

  before do
    without_partial_double_verification do
      allow(Fastenv)
        .to receive(:blog_output_path)
        .and_return(fake_blog_output_path)
    end
  end
end

# TODO: This isn't as reusable as I'd hoped. Need to also set the TEMPLATES_PATH
# env var.
shared_context 'with an index template' do
  let(:index_template_file_path) do
    Everything::Blog::Output::IndexTemplate.new('').template_path
  end

  before do
    FakeFS::FileSystem.clone(index_template_file_path)
  end
end

# TODO: This isn't as reusable as I'd hoped. Need to also set the TEMPLATES_PATH
# env var.
shared_context 'with a post template' do
  let(:post_template_file_path) do
    Everything::Blog::Output::PostTemplate.new('').template_path
  end

  before do
    FakeFS::FileSystem.clone(post_template_file_path)
  end
end

shared_examples 'raises an error for template not existing' do
  it 'raises an error for the template not existing' do
    expect{action}
      .to raise_error(Errno::ENOENT, /No such file/)
  end
end

shared_examples 'raises an error for stylesheet not existing' do
  it 'raises an error for the stylesheet not existing' do
    expect{action}
      .to raise_error(Errno::ENOENT, /No such file/)
  end
end

shared_context 'with fake png' do
  include_context 'stub out everything path'
  include_context 'with fakefs'

  let(:test_png_file_path) do
    File.join(
      RSpec::Core::RubyProject.root,
      'spec',
      'data',
      '1x1_black_square.png')
  end
  let(:test_png_data) do
    FakeFS::FileSystem.clone(test_png_file_path)
    File.binread(test_png_file_path)
  end
  let(:given_png_file_name) do
    'image.png'
  end
  let(:given_png_dir_path) do
    File.join(Everything::Blog::Source.absolute_path, given_post_name)
  end
  let(:given_png_file_path) do
    File.join(given_png_dir_path, given_png_file_name)
  end
  let(:given_post_name) do
    'not-a-real-post'
  end

  before do
    FileUtils.mkdir_p(given_png_dir_path)

    File.open(given_png_file_path, 'wb') do |f|
      f.write(test_png_data)
    end
  end

  after do
    FileUtils.rm_rf(given_png_dir_path)
  end
end

shared_context 'with fake source media' do
  include_context 'with fake png'

  let(:fake_source_media) do
    Everything::Blog::Source::Media.new(given_png_file_path)
  end
end

shared_context 'with fake output media' do
  include_context 'with fake source media'

  let(:fake_output_media) do
    Everything::Blog::Output::Media.new(fake_source_media)
  end
end

shared_context 'with fake binary file in s3' do
  include_context 'with mock bucket in s3'
  include_context 'with fake output media'

  let(:expected_file_name) {
    fake_output_media.path.to_s
  }
  let(:mock_binary_data) { test_png_data }
  let!(:mock_binary_file) do
    mock_s3_bucket.files.create(
      {
        key: expected_file_name,
        body: mock_binary_data
      }
    )
  end

  after do
    mock_s3_bucket.files.each(&:destroy)
  end
end

# TODO: Want to remove this...
shared_context 'when templates_path is not set' do
  # TODO: Is there a better way to test this stuff than actually setting and
  # deleting env vars?
  before do
    @original_templates_path = ENV['TEMPLATES_PATH']
    ENV.delete('TEMPLATES_PATH')
  end

  after do
    ENV['TEMPLATES_PATH'] = @original_templates_path
  end
end

# TODO: Want to remove this...
shared_context 'when templates_path is set' do
  let(:given_templates_path) do
    Pathname.new('/some/fake/path')
  end

  # TODO: Is there a better way to test this stuff than actually setting and
  # deleting env vars?
  before do
    @original_templates_path = ENV['TEMPLATES_PATH']
    ENV['TEMPLATES_PATH'] = given_templates_path
  end

  after do
    ENV['TEMPLATES_PATH'] = @original_templates_path
  end
end

shared_examples 'raises an error about the env var' do
  it 'raises an error that the env var is not set' do
    # TODO: Should this raise a better named error?
    expect{action}.to raise_error(NameError)
  end
end

shared_context 'with a fake template file' do
  before do
    FileUtils.mkdir_p(given_template.templates_path)
    File.write(given_template.template_path, '')
  end
end

shared_examples 'renders the template with Tilt' do
  it 'passes the template_path to Tilt' do
    allow(Tilt)
      .to receive(:new)
      .with(given_template.template_path)
      .and_call_original

    given_template.merge_content_and_template

    expect(Tilt).to have_received(:new).with(given_template.template_path)
  end

  it 'renders using the given template_context' do
    fake_erb_template = double(Tilt::ERBTemplate)

    allow(Tilt)
      .to receive(:new)
      .and_return(fake_erb_template)
    allow(fake_erb_template)
      .to receive(:render)
      .with(given_template_context)

    given_template.merge_content_and_template

    expect(fake_erb_template)
      .to have_received(:render)
      .with(given_template_context)
  end

  it 'renders using the given content_html' do
    fake_erb_template = double(Tilt::ERBTemplate)

    allow(Tilt)
      .to receive(:new)
      .and_return(fake_erb_template)

    # Note: Found this helpful approach to verify the block value:
    # https://stackoverflow.com/a/31996525/249218
    expect(fake_erb_template)
      .to receive(:render) do |&block|
        expect(block.call).to eq(given_content_html)
    end

    given_template.merge_content_and_template
  end
end

shared_examples 'behaves like a TemplateBase' do
  describe '#initialize' do
    context 'when content_html is not given' do
      let(:given_template) do
        described_class.new
      end

      it 'raises an ArgumentError' do
        expect{given_template}.to raise_error(ArgumentError)
      end
    end

    context 'when content_html is given' do
      context 'when template_context is not given' do
        let(:given_template) do
          described_class.new(given_content_html)
        end

        it 'raises no ArgumentError' do
          expect{given_template}.not_to raise_error
        end

        it 'sets the content_html attr' do
          expect(given_template.content_html).to eq(given_content_html)
        end

        it 'defaults the template_context attr to nil' do
          expect(given_template.template_context).to eq(nil)
        end
      end

      context 'when template_context is given' do
        let(:given_template) do
          described_class.new(given_content_html, given_template_context)
        end

        it 'raises no ArgumentError' do
          expect{given_template}.not_to raise_error
        end

        it 'sets the content_html attr' do
          expect(given_template.content_html).to eq(given_content_html)
        end

        it 'sets the template_context attr' do
          expect(given_template.template_context).to eq(given_template_context)
        end
      end
    end
  end

  describe '#content_html' do
    it 'is a method' do
      expect(given_template).to respond_to(:content_html)
    end
  end

  describe '#template_context' do
    it 'is a method' do
      expect(given_template).to respond_to(:template_context)
    end
  end

  it 'has a TEMPLATE_NAME constant' do
    expect(described_class).to have_constant(:TEMPLATE_NAME)
  end

  describe '#template_name' do
    it 'is the TEMPLATE_NAME constant' do
      expect(given_template.template_name).to eq(described_class::TEMPLATE_NAME)
    end
  end

  describe '#template_path' do
    context 'when templates_path is not set' do
      include_context 'when templates_path is not set'

      include_examples 'raises an error about the env var'
    end

    context 'when templates path is set' do
      include_context 'stub out templates path'

      let(:expected_template_path) do
        Pathname.new(
          Fastenv.templates_path
        ).join(described_class::TEMPLATE_NAME)
      end

      it 'is the path for the template under the templates_path' do
        expect(given_template.template_path).to eq(expected_template_path)
      end
    end
  end

  describe '#templates_path' do
    context 'when the env var is not set' do
      include_context 'when templates_path is not set'

      it 'raises an error that the env var is not set' do
        expect{given_template.templates_path}.to raise_error(NameError)
      end
    end

    context 'when the env var is set' do
      include_context 'stub out templates path'

      it 'returns the environment var' do
        expect(given_template.templates_path)
          .to eq(Pathname.new(fake_templates_path))
      end
    end
  end
end

shared_context 'with fake stylesheet' do
  include FakeFS::SpecHelpers

  include_context 'stub out everything path'

  let(:given_stylesheet_content) do
    'p { font-size: 1em; }'
  end

  before do
    FakeFS do
      fake_stylesheet_file_path = Everything.path.join('css')
      FileUtils.mkdir_p(fake_stylesheet_file_path)
      stylesheet_filename = fake_stylesheet_file_path.join('style.css')
      stylesheet_filename.write(given_stylesheet_content)
    end
  end
end

shared_context 'with fake aws_access_key_id env var' do
  let(:fake_env_value) { 'fake_env_value' }

  before do
    ENV['AWS_ACCESS_KEY_ID'] = fake_env_value
  end
end

shared_context 'with fake aws_secret_access_key env var' do
  let(:fake_env_value) { 'fake_env_value' }

  before do
    ENV['AWS_SECRET_ACCESS_KEY'] = fake_env_value
  end
end

shared_context 'with fake aws_storage_bucket env var' do
  let(:fake_env_value) { 'fake_env_value' }

  before do
    ENV['AWS_STORAGE_BUCKET'] = fake_env_value
  end
end

shared_context 'with fake aws_storage_region env var' do
  let(:fake_env_value) { 'us-east-1' }

  before do
    ENV['AWS_STORAGE_REGION'] = fake_env_value
  end
end

shared_context 'with fake aws env vars' do
  include_context 'with fake aws_access_key_id env var'
  include_context 'with fake aws_secret_access_key env var'
  include_context 'with fake aws_storage_bucket env var'
  include_context 'with fake aws_storage_region env var'
end

shared_context 'with mock fog' do
  before do
    Fog.mock!
  end
end

shared_context 'with mock bucket in s3' do
  include_context 'with fake aws env vars'
  include_context 'with mock fog'

  let(:expected_bucket_name) do
    Fastenv.aws_storage_bucket
  end

  let(:mock_s3_bucket) do
    Everything::Blog::S3Bucket.new
  end

  before do
    mock_s3_bucket
      .s3_connection
      .directories
      .create(key: expected_bucket_name)
  end

  after do
    bucket = mock_s3_bucket
      .s3_connection
      .directories
      .get(expected_bucket_name)

    if bucket&.files&.any?
      puts "##################################################"
      puts "##################################################"
      puts "##################################################"
      puts "WARNING: File(s) exist in bucket:"
      puts bucket.files.map(&:key)
    end

    bucket&.destroy
  end
end

shared_context 'with fake html file in s3' do
  include_context 'with mock bucket in s3'

  let(:expected_file_name) { 'index.html' }
  let(:mock_html_body) { '<html></html>' }
  let!(:mock_html_file) do
    mock_s3_bucket.files.create(
      {
        key: expected_file_name,
        body: mock_html_body
      }
    )
  end

  after do
    mock_s3_bucket.files.each(&:destroy)
  end
end

shared_context 'with fake source index' do
  let(:fake_source_index) do
    Everything::Blog::Source::Index.new({'some-title' => 'Blah'})
  end
end

shared_context 'with fake output index' do
  include_context 'with fake source index'

  let(:fake_output_index) do
    Everything::Blog::Output::Index.new(fake_source_index)
  end
end

shared_context 'with fake post' do
  include_context 'with fake piece'

  let(:fake_post) do
    Everything::Blog::Post.new(given_post_name)
  end
end

shared_context 'with fake source page' do
  include_context 'with fake post'

  let(:fake_source_page) do
    Everything::Blog::Source::Page.new(fake_post)
  end
end

shared_context 'with fake output page' do
  include_context 'with fake source page'

  let(:fake_output_page) do
    Everything::Blog::Output::Page.new(fake_source_page)
  end
end

shared_context 'with fake source stylesheet' do
  let(:fake_source_stylesheet) do
    Everything::Blog::Source::Stylesheet.new
  end
end

shared_context 'with fake output stylesheet' do
  include_context 'with fake source stylesheet'

  let(:fake_output_stylesheet) do
    Everything::Blog::Output::Stylesheet.new(fake_source_stylesheet)
  end
end

shared_context 'with fake stylesheet file in s3' do
  include_context 'with mock bucket in s3'

  let(:expected_file_name) { 'css/style.css' }
  let(:mock_stylesheet_body) { 'html { font-size: 1em; }' }
  let!(:mock_stylesheet_file) do
    mock_s3_bucket.files.create(
      {
        key: expected_file_name,
        body: mock_stylesheet_body
      }
    )
  end

  after do
    mock_s3_bucket.files.each(&:destroy)
  end
end

shared_context 'with fake logger' do
  let(:fake_logger) do
    Everything::Logger::Debug.new(fake_output, progname: described_class.to_s)
  end

  let(:fake_output) do
    StringIO.new
  end

  before do
    Everything.logger = fake_logger
  end
end

shared_context 'with debug logger' do
  let(:debug_logger) do
    Everything::Blog.debug_logger
  end

  before do
    Everything.logger = debug_logger
  end
end

shared_context 'with error logger' do
  let(:error_logger) do
    Everything::Blog.error_logger
  end

  before do
    Everything.logger = error_logger
  end
end

