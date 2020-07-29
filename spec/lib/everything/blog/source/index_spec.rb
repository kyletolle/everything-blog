require 'spec_helper'

describe Everything::Blog::Source::Index do
  let(:given_page_names_and_titles) do
    {
      'bits-and-bytes'             => 'Bits and Bytes',
      'many-things-have-been-said' => 'Many Things Have Been Said'
    }
  end
  let(:index) do
    described_class.new(given_page_names_and_titles)
  end

  describe '#absolute_dir' do
    include_context 'stub out everything path'

    let(:expected_absolute_dir) do
      Pathname.new('/fake/everything/path')
    end

    it 'is the absolute dir for the index' do
      expect(index.absolute_dir).to eq(expected_absolute_dir)
    end

    it 'memoizes the value' do
      first_call_value = index.absolute_dir
      second_call_value = index.absolute_dir
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  describe '#absolute_path' do
    include_context 'stub out everything path'

    let(:expected_absolute_path) do
      Pathname.new('/fake/everything/path/index.html')
    end

    it 'is the absolute path for the index' do
      expect(index.absolute_path).to eq(expected_absolute_path)
    end

    it 'memoizes the value' do
      first_call_value = index.absolute_path
      second_call_value = index.absolute_path
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  describe '#content' do
    let(:actual_content) do
      index.content
    end
    let(:actual_content_lines) do
      actual_content.split("\n")
    end

    it 'is a string with as many lines as the number of pages passed in' do
      actual_line_count = actual_content_lines.count

      expected_line_count = given_page_names_and_titles.count
      expect(actual_line_count).to eq(expected_line_count)
    end

    it 'is a markdown list of links using page titles as link text and names as link path' do
      expected_markdown_content =
        <<~MD
          - [Bits and Bytes](/bits-and-bytes/)
          - [Many Things Have Been Said](/many-things-have-been-said/)
        MD
        .chop

      expect(actual_content).to match(expected_markdown_content)
    end
  end

  describe '#dir' do
    let(:expected_dir) do
      Pathname.new(described_class::DIR)
    end

    it 'is the default index dir' do
      expect(index.dir).to eq(expected_dir)
    end

    it 'memoizes the value' do
      first_call_value = index.dir
      second_call_value = index.dir
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  describe '#file_name' do
    let(:expected_file_name) do
      Pathname.new(described_class::FILE_NAME)
    end

    it 'is index.html' do
      expect(index.file_name).to eq(expected_file_name)
    end

    it 'memoizes the value' do
      first_call_value = index.file_name
      second_call_value = index.file_name
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  describe '#path' do
    let(:expected_path) do
      Pathname.new('index.html')
    end

    it 'is the index file in the root path, without a leading slash' do
      expect(index.path).to eq(expected_path)
    end

    it 'memoizes the value' do
      first_call_value = index.path
      second_call_value = index.path
      expect(first_call_value.object_id).to eq(second_call_value.object_id)
    end
  end

  # TODO: Test the methods inherited from Source::FileBase too.
  # include_context 'acts like a source file'

  describe '#==' do
    context 'when the other object does not respond to #content' do
      let(:other_object) { nil }

      it 'is false' do
        expect(index == other_object).to eq(false)
      end
    end

    context 'when the other object responds to #content' do
      context 'when the other index has different page names and titles' do
        let(:different_page_names_and_titles) do
          {
            'chunks-and-chops' => 'Chunks and Chops',
            'wheeble-whobble'  => 'Wheeble Whobble'
          }
        end
        let(:other_index) do
          described_class.new(different_page_names_and_titles)
        end

        it 'is false' do
          expect(index == other_index).to eq(false)
        end
      end

      context 'when the other index has the same page names and titles' do
        let(:other_index) do
          described_class.new(given_page_names_and_titles)
        end

        it 'is true' do
          expect(index == other_index).to eq(true)
        end
      end
    end
  end

  describe '#inspect' do
    let(:inspect_output_regex) do
      /#<#{described_class}: dir: `#{index.dir}`, file_name: `#{index.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(index.inspect).to match(inspect_output_regex)
    end
  end
end

