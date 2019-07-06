require 'spec_helper'
require 'fakefs/spec_helpers'

describe Everything::Blog::Output::Media do
  include FakeFS::SpecHelpers

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

  describe '#output_file_path' do
    let(:expected_output_file_path) do
      File.join(fake_blog_output_path, given_post_name, media.output_file_name)
    end

    it 'is the full path for the output file' do
      expect(media.output_file_path).to eq(expected_output_file_path)
    end
  end

  describe "#relative_dir_path" do
    it "should be the same path as the source media" do
      expect(media.relative_dir_path).to eq(source_media.relative_dir_path)
    end
  end

  describe '#relative_file_path' do
    it 'should be the same path as the source index' do
      expect(media.relative_file_path)
        .to eq(source_media.relative_file_path)
    end
  end

  describe '#save_file' do
    context 'when the media output dir path does not already exist' do
      it 'creates it' do
        expect(Dir.exist?(media.output_dir_path)).to eq(false)

        media.save_file

        expect(Dir.exist?(media.output_dir_path)).to eq(true)
      end
    end

    context 'when the media output dir path already exists' do
      let(:fake_file_path) do
        File.join(media.output_dir_path, 'something.txt')
      end

      before do
        FileUtils.mkdir_p(media.output_dir_path)
        # File.binwrite(fake_file_path, test_png_data)
        File.open(fake_file_path, 'wb') {|f| f.write(test_png_data)}
      end

      after do
        FileUtils.rm(fake_file_path)
        FileUtils.rm(media.output_file_path)
        FileUtils.rmdir(media.output_dir_path)
      end

      it 'keeps the folder out there' do
        expect(Dir.exist?(media.output_dir_path)).to eq(true)

        media.save_file

        expect(Dir.exist?(media.output_dir_path)).to eq(true)
      end

      it 'does not clear existing files in the folder' do
        expect(File.exist?(fake_file_path)).to eq(true)

        media.save_file

        expect(File.exist?(fake_file_path)).to eq(true)
      end
    end

    context 'when the file does not already exist' do
      it 'creates it' do
        expect(File.exist?(media.output_file_path)).to eq(false)

        media.save_file

        expect(File.exist?(media.output_file_path)).to eq(true)
      end

      it 'writes the media file data' do
        media.save_file

        expected_png_binary_data = test_png_data
        media_file_data = File.binread(media.output_file_path)
        expect(media_file_data).to match(expected_png_binary_data)
      end
    end

    context 'when the file already exists' do
      before do
        FileUtils.mkdir_p(media.output_dir_path)
        File.write(media.output_file_path, 'random text')
      end

      it 'does not delete the file' do
        expect(File.exist?(media.output_file_path)).to eq(true)

        media.save_file

        expect(File.exist?(media.output_file_path)).to eq(true)
      end

      it 'overwrites it with the correct file data' do
        media_file_data = File.binread(media.output_file_path)
        expect(media_file_data).not_to match(test_png_data)

        media.save_file

        expected_png_binary_data = test_png_data
        media_file_data = File.binread(media.output_file_path)
        expect(media_file_data).to match(expected_png_binary_data)
      end
    end
  end

  describe '#source_file' do
    it 'returns the source media it was created with' do
      expect(media.source_file).to eq(source_media)
    end
  end

  describe '#should_generate_output?' do
    # TODO: Add detection for whether the Media should generate or not.
    it 'should be true' do
      expect(media.should_generate_output?).to eq(true)
    end
  end

  describe '#template_klass' do
    it 'is not implemented' do
      expect{media.template_klass}.to raise_error(NotImplementedError)
    end
  end
end

