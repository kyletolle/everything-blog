require 'spec_helper'

describe Everything::Blog::Source::Media do
  include_context 'with fake png'

  let(:given_absolute_path) do
    given_png_file_path
  end
  let(:media) do
    described_class.new(given_absolute_path)
  end

  describe '#absolute_dir' do
    let(:expected_absolute_dir) do
      Pathname.new('/fake/everything/path/blog/not-a-real-post')
    end

    it 'is the absolute dir for the media' do
      expect(media.absolute_dir).to eq(expected_absolute_dir)
    end

    it 'memoizes the value' do
      first_call_value = media.absolute_dir
      second_call_value = media.absolute_dir
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  describe '#absolute_path' do
    let(:expected_absolute_path) do
      Pathname.new('/fake/everything/path/blog/not-a-real-post/image.png')
    end

    it 'is the absolute path for the media' do
      expect(media.absolute_path).to eq(expected_absolute_path)
    end

    it 'memoizes the value' do
      first_call_value = media.absolute_path
      second_call_value = media.absolute_path
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  describe '#content' do
    it "is the given file's binary data" do
      expect(media.content).to eq(test_png_data)
    end
  end

  describe '#dir' do
    let(:expected_dir) do
      Pathname.new('not-a-real-post')
    end

    it 'is the relative dir of the media' do
      expect(media.dir).to eq(expected_dir)
    end

    it 'memoizes the value' do
      first_call_value = media.dir
      second_call_value = media.dir
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  describe '#file_name' do
    let(:expected_file_name) do
      Pathname.new(given_png_file_name)
    end

    it "is the given file's file name" do
      expect(media.file_name).to eq(expected_file_name)
    end

    it 'memoizes the value' do
      first_call_value = media.file_name
      second_call_value = media.file_name
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  describe '#path' do
    include_context 'stub out everything path'

    let(:expected_path) do
      Pathname.new('not-a-real-post').join(given_png_file_name)
    end

    it 'is the joining of the relative dir and file name' do
      expect(media.path).to eq(expected_path)
    end

    it 'memoizes the value' do
      first_call_value = media.path
      second_call_value = media.path
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  describe '#==' do
    context 'when the other object does not respond to #absolute_path' do
      let(:other_object) { nil }

      it 'is false' do
        expect(media == other_object).to eq(false)
      end
    end

    context 'when the other object does respond to #absolute_path' do
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
          described_class.new(given_absolute_path)
        end

        it 'is true' do
          expect(media == other_media).to eq(true)
        end
      end
    end
  end

  describe '#inspect' do
    let(:inspect_output_regex) do
      /#<#{described_class}: dir: `#{media.dir}`, file_name: `#{media.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(media.inspect).to match(inspect_output_regex)
    end
  end

  # TODO: Test the methods inherited from Source::FileBase too.
  # include_context 'acts like a source file'
end

