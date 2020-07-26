require 'spec_helper'
require 'fakefs/spec_helpers'

describe Everything::Blog::Source::Media do
  include FakeFS::SpecHelpers

  include_context 'with fake png'

  let(:given_source_file_path) do
    given_png_file_path
  end
  let(:media) do
    described_class.new(given_source_file_path)
  end

  describe '#absolute_dir' do
    let(:expected_absolute_dir) do
      '/fake/everything/path/blog/not-a-real-post'
    end
    it 'is the absolute dir for the media' do
      expect(media.absolute_dir).to eq(expected_absolute_dir)
    end
  end

  describe '#absolute_path' do
    let(:expected_absolute_path) do
      '/fake/everything/path/blog/not-a-real-post/image.png'
    end
    it 'is the absolute path for the media' do
      expect(media.absolute_path).to eq(expected_absolute_path)
    end
  end

  describe '#content' do
    it "is the given file's binary data" do
      expect(media.content).to eq(test_png_data)
    end
  end

  describe '#dir' do
    let(:expected_dir) do
      'not-a-real-post'
    end
    it 'is the dir of the media' do
      expect(media.dir).to eq(expected_dir)
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

  describe '#==' do
    context 'when the other object does not respond to #source_file_path' do
      let(:other_object) { nil }

      it 'is false' do
        expect(media == other_object).to eq(false)
      end
    end

    context 'when the other object does respond to #source_file_path' do
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

  describe '#inspect' do
    let(:inspect_output_regex) do
      /#<#{described_class}: path: `#{media.relative_dir_path}`, file_name: `#{media.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(media.inspect).to match(inspect_output_regex)
    end
  end

  # TODO: Test the methods inherited from Source::FileBase too.
  # include_context 'acts like a source file'

  describe "#relative_dir_path" do
    let(:expected_relative_dir_path) do
      'not-a-real-post'
    end

    it 'is a relative path to the dir, without a leading slash' do
      expect(media.relative_dir_path).to eq(expected_relative_dir_path)
    end
  end

  describe "#relative_file_path" do
    let(:expected_relative_file_path) do
      'not-a-real-post/image.png'
    end

    it 'is a relative path to the file, without a leading slash' do
      expect(media.relative_file_path).to eq(expected_relative_file_path)
    end
  end
end

