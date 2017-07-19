require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/page'
require './spec/support/shared'
require 'fakefs/spec_helpers'

describe Everything::Blog::Source::Page do
  include FakeFS::SpecHelpers

  include_context 'with fake piece'
  let(:piece_path) do
    # We want to create our fake posts in the blog directory.
    File.join(Everything::Blog::Source.absolute_path, given_post_name)
  end

  let(:post) do
    Everything::Blog::Post.new(given_post_name)
  end
  let(:page) do
    described_class.new(post)
  end

  let(:expected_markdown_file_name) do
    'index.md'
  end

  describe '#content' do
    it "is the post's content" do
      expect(page.content).to eq(fake_piece_body)
    end
  end

  describe '#file_name' do
    it "is post's markdown file" do
      expect(page.file_name).to eq(expected_markdown_file_name)
    end
  end

  describe '#relative_dir_path' do
    let(:expected_relative_dir_path) do
      File.join('', fake_post_name)
    end
    it 'is a relative path to the dir' do
      expect(page.relative_dir_path).to eq(expected_relative_dir_path)
    end
  end

  describe '#relative_file_path' do
    let(:expected_relative_file_path) do
      File.join('', fake_post_name, expected_markdown_file_name)
    end
    it 'is a relative path to the file' do
      expect(page.relative_file_path).to eq(expected_relative_file_path)
    end
  end
end
