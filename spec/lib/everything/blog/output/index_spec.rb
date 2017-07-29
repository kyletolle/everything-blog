require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/index'
require 'fakefs/spec_helpers'
require './spec/support/shared'
require './spec/support/post_helpers'

describe Everything::Blog::Output::Index do
  include FakeFS::SpecHelpers
  include PostHelpers

  include_context 'with fakefs'
  include_context 'create blog path'
  include_context 'stub out blog output path'

  before do
    create_post('some-title', is_public: true)
  end

  after do
    delete_post('some-title')
  end

  let(:source_index) do
    Everything::Blog::Source::Index.new({'some-title' => 'Blah'})
  end
  let(:index) do
    described_class.new(source_index)
  end

  describe '#output_file_name' do
    it 'is an index html file' do
      expect(index.output_file_name).to eq('index.html')
    end
  end

  describe '#output_file_path' do
    let(:expected_output_file_path) do
      File.join(fake_blog_output_path, index.output_file_name)
    end
    it 'is the full path for the output file' do
      expect(index.output_file_path).to eq(expected_output_file_path)
    end
  end

  describe '#relative_dir_path' do
    it 'should be the same path as the source index' do
      expect(index.relative_dir_path).to eq(source_index.relative_dir_path)
    end
  end

  describe '#should_generate_output?' do
    # TODO: Add detection for whether the Index should generate or not.
    it 'should be true' do
      expect(index.should_generate_output?).to eq(true)
    end
  end
end

