require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/page'
require './spec/support/shared'
require './spec/support/post_helpers'
require 'fakefs/spec_helpers'

describe Everything::Blog::Source::Page do
  include FakeFS::SpecHelpers
  include PostHelpers

  include_context 'with fake piece'
  let(:given_piece_path) do
    # We want to create our fake posts in the blog directory.
    File.join(Everything::Blog::Source.absolute_path, given_post_name)
  end

  let(:given_post) do
    Everything::Blog::Post.new(given_post_name)
  end
  let(:page) do
    described_class.new(given_post)
  end

  let(:expected_markdown_file_name) do
    'index.md'
  end

  describe '#content' do
    it "is the given post's content" do
      expect(page.content).to eq(fake_piece_body)
    end
  end

  describe '#file_name' do
    it "is given post's markdown file" do
      expect(page.file_name).to eq(expected_markdown_file_name)
    end
  end

  describe '#post' do
    it 'is the given post' do
      expect(page.post).to eq(given_post)
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

  # TODO: Implement this
  describe '#==' do
    include_context 'with fakefs'
    include_context 'create blog path'

    context "when the other page's post's full path does not match" do
      before do
        create_post('some-title', 'Some Title', 'Some body text here.')
      end

      after do
        delete_post('some-title')
      end

      let(:other_post) do
        Everything::Blog::Post.new('some-title')
      end
      let(:other_page) do
        described_class.new(other_post)
      end

      it 'is false' do
        expect(page == other_page).to eq(false)
      end
    end

    context "when the other page's post's full path matches" do
      let(:other_post) do
        Everything::Blog::Post.new(given_post_name)
      end
      let(:other_page) do
        described_class.new(other_post)
      end

      it 'is true' do
        expect(page == other_page).to eq(true)
      end
    end
  end
end
