require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/media'
require './spec/support/shared'
require 'fakefs/spec_helpers'

describe Everything::Blog::Source::Media do
  include FakeFS::SpecHelpers

  shared_context 'with fake png' do
    include_context 'stub out everything path'

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
      FakeFS.activate!

      FileUtils.mkdir_p(given_png_dir_path)

      File.open(given_png_file_path, 'wb') do |f|
        f.write(test_png_data)
      end
    end

    after do
      FileUtils.rm_rf(given_png_dir_path)

      FakeFS.deactivate!
    end
  end

  include_context 'with fake png'

  let(:given_source_file_path) do
    given_png_file_path
  end
  let(:media) do
    described_class.new(given_source_file_path)
  end

  describe '#content' do
    it "is the given file's binary data" do
      expect(media.content).to eq(test_png_data)
    end
  end

  describe '#file_name' do
    it "is the given file's file name" do
      expect(media.file_name).to eq(given_png_file_name)
    end
  end

  describe '#source_file_path' do
    it 'is the given source file path' do
      expect(media.source_file_path).to eq(given_source_file_path)
    end
  end

  # TODO: Implement this
  describe '#==' do
    context "when the other media's file path doesn't match" do
      let(:other_media) do
        described_class.new('/some/other/media/file.png')
      end

      it 'is false' do
        expect(media == other_media).to eq(false)
      end
    end

    context "when the other media's file path matches" do
      let(:other_media) do
        described_class.new(given_source_file_path)
      end

      it 'is true' do
        expect(media == other_media).to eq(true)
      end
    end
  end
end

