require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/index'
require 'fakefs/spec_helpers'
require './spec/support/shared'
require './spec/support/post_helpers'

describe Everything::Blog::Output::Media do
  include FakeFS::SpecHelpers
  include PostHelpers

  include_context 'with fakefs'
  include_context 'create blog path'
  include_context 'stub out blog output path'

  include_context 'with fake png'

  let(:source_media) do
    Everything::Blog::Source::Media.new(given_png_file_path)
  end
  let(:media) do
    described_class.new(source_media)
  end

  describe '#output_content' do
    it 'is the source content' do
      expect(media.output_content).to eq(source_media.content)
    end
  end

  describe '#output_file_name' do
    it 'is the source file name' do
      expect(media.output_file_name).to eq(source_media.file_name)
    end
  end

  describe '#content_type' do
    context 'when file has a jpg extension' do
      before do
        allow(source_media).to receive(:source_file_path)
          .and_return('/some/path/to/test.jpg')
      end

      it 'is the jpg MIME type' do
        expect(media.content_type).to eq('image/jpeg')
      end
    end

    context 'when the file has a gif extension' do
      before do
        allow(source_media).to receive(:source_file_path)
          .and_return('/some/path/to/test.gif')
      end

      it 'is the gif MIME type' do
        expect(media.content_type).to eq('image/gif')
      end
    end

    context 'when the file has a png extension' do
      before do
        allow(source_media).to receive(:source_file_path)
          .and_return('/some/path/to/test.png')
      end

      it 'is the png MIME type' do
        expect(media.content_type).to eq('image/png')
      end
    end

    context 'when the file has a mp3 extension' do
      before do
        allow(source_media).to receive(:source_file_path)
          .and_return('/some/path/to/test.mp3')
      end

      it 'is the mpeg MIME type' do
        expect(media.content_type).to eq('audio/mpeg')
      end
    end
  end

  describe '#output_dir_path' do
    let(:expected_output_dir_path) do
      File.join(fake_blog_output_path, given_post_name)
    end

    it 'is the full path for the output dir' do
      expect(media.output_dir_path).to eq(expected_output_dir_path)
    end
  end


  describe "#relative_dir_path" do
    it "should be the same path as the source media" do
      expect(media.relative_dir_path).to eq(source_media.relative_dir_path)
    end
  end
end

