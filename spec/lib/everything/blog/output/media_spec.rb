require 'spec_helper'

describe Everything::Blog::Output::Media do
  include_context 'stub out everything path'
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

  describe '#inspect' do
    let(:inspect_output_regex) do
      /#<#{described_class}: dir: `#{media.dir}`, file_name: `#{media.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(media.inspect).to match(inspect_output_regex)
    end
  end

  describe '#output_content' do
    it 'is the source content' do
      expect(media.output_content).to eq(source_media.content)
    end
  end

  describe '#file_name' do
    it 'is the source file name' do
      expect(media.file_name).to eq(source_media.file_name)
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

  describe '#absolute_dir' do
    let(:expected_output_dir_path) do
      Pathname.new(
        File.join(fake_blog_output_path, given_post_name)
      )
    end

    it 'is the full path for the output dir' do
      expect(media.absolute_dir).to eq(expected_output_dir_path)
    end
  end

  describe '#absolute_path' do
    let(:expected_output_file_path) do
      Pathname.new(
        File.join(
          fake_blog_output_path,
          given_post_name,
          media.file_name
        )
      )
    end

    it 'is the full path for the output file' do
      expect(media.absolute_path).to eq(expected_output_file_path)
    end
  end

  describe "#dir" do
    it "should be the same path as the source media" do
      expect(media.dir).to eq(source_media.dir)
    end
  end

  describe '#path' do
    it 'should be the same path as the source index' do
      expect(media.path).to eq(source_media.path)
    end
  end

  describe '#save_file' do
    context 'when the media output dir path does not already exist' do
      before do
        FileUtils.rm_rf(media.absolute_dir)
      end

      it 'creates it' do
        # TODO: Replace the many Dir.exist? and File.exist?/join with their
        # Pathname equivalents.
        expect(media.absolute_dir).not_to exist

        media.save_file

        expect(media.absolute_dir).to exist
      end
    end

    context 'when the media output dir path already exists' do
      let(:fake_file_path) do
        File.join(media.absolute_dir, 'something.txt')
      end

      before do
        FileUtils.mkdir_p(media.absolute_dir)
        # File.binwrite(fake_file_path, test_png_data)
        File.open(fake_file_path, 'wb') {|f| f.write(test_png_data)}
      end

      after do
        FileUtils.rm(fake_file_path)
        FileUtils.rm(media.absolute_path)
        FileUtils.rmdir(media.absolute_dir)
      end

      it 'keeps the folder out there' do
        expect(Dir.exist?(media.absolute_dir)).to eq(true)

        media.save_file

        expect(Dir.exist?(media.absolute_dir)).to eq(true)
      end

      it 'does not clear existing files in the folder' do
        expect(File.exist?(fake_file_path)).to eq(true)

        media.save_file

        expect(File.exist?(fake_file_path)).to eq(true)
      end
    end

    context 'when the file does not already exist' do
      it 'creates it' do
        expect(File.exist?(media.absolute_path)).to eq(false)

        media.save_file

        expect(File.exist?(media.absolute_path)).to eq(true)
      end

      it 'writes the media file data' do
        media.save_file

        expected_png_binary_data = test_png_data
        media_file_data = File.binread(media.absolute_path)
        expect(media_file_data).to match(expected_png_binary_data)
      end
    end

    context 'when the file already exists' do
      before do
        FileUtils.mkdir_p(media.absolute_dir)
        File.write(media.absolute_path, 'random text')
      end

      it 'does not delete the file' do
        expect(File.exist?(media.absolute_path)).to eq(true)

        media.save_file

        expect(File.exist?(media.absolute_path)).to eq(true)
      end

      it 'overwrites it with the correct file data' do
        media_file_data = File.binread(media.absolute_path)
        expect(media_file_data).not_to match(test_png_data)

        media.save_file

        expected_png_binary_data = test_png_data
        media_file_data = File.binread(media.absolute_path)
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

