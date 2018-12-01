require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/page'
require 'fakefs/spec_helpers'
require './spec/support/shared'

describe Everything::Blog::Output::Page do
  include FakeFS::SpecHelpers

  include_context 'with fakefs'
  include_context 'create blog path'
  include_context 'stub out blog output path'

  # Create a post so we can make a page from it
  # Note: Borrowed some of this from blog/source/page_spec
  include_context 'with fake piece'
  let(:given_piece_path) do
    # We want to create our fake posts in the blog directory.
    File.join(Everything::Blog::Source.absolute_path, given_post_name)
  end
  let(:given_post) do
    Everything::Blog::Post.new(given_post_name)
  end

  let(:given_source_page) do
    Everything::Blog::Source::Page.new(given_post)
  end
  let(:page) do
    described_class.new(given_source_page)
  end

  describe '#should_generate_output?' do
    # TODO: Want to make this smarter and use the conditionals in code, but need
    # to have tests for that...
    it 'is always true' do
      expect(page.should_generate_output?).to eq(true)
    end
  end

  describe '#source_file' do
    it 'is the given source page' do
      expect(page.source_file).to eq(given_source_page)
    end
  end

  describe '#template_context' do
    it "is the source file's post" do
      expect(page.template_context).to eq(given_post)
    end
  end

  describe '#output_file_name' do
    it 'is index.html' do
      expect(page.output_file_name).to eq('index.html')
    end
  end

  describe '#output_file_path' do
    it 'is the full path of the post dir and the index.html' do
      expect(page.output_file_path).to eq('/fake/blog/output/grond-crawled-on/index.html')
    end
  end

  describe '#output_dir_path' do
    it 'is the full path of the post dir' do
      expect(page.output_dir_path).to eq('/fake/blog/output/grond-crawled-on')
    end
  end

  describe '#relative_dir_path' do
    it 'is the relative path of the post dir' do
      expect(page.relative_dir_path).to eq('/grond-crawled-on')
    end
  end

  describe '#save_file'
end

