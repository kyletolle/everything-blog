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
      '/fake/everything/path'
    end
    it 'is the absolute dir for the index' do
      expect(index.absolute_dir).to eq(expected_absolute_dir)
    end
  end

  describe '#absolute_path' do
    include_context 'stub out everything path'

    let(:expected_absolute_path) do
      '/fake/everything/path/index.html'
    end
    it 'is the absolute dir for the index' do
      expect(index.absolute_path).to eq(expected_absolute_path)
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
    let(:expected_dir) { described_class::DIR }
    it 'is the default index dir' do
      expect(index.dir).to eq(expected_dir)
    end
  end

  describe '#file_name' do
    it 'is index.html' do
      expect(index.file_name).to eq(described_class::FILE_NAME)
    end
  end

  describe '#path' do
    let(:expected_path) do
      'index.html'
    end
    # TODO: I don't remember why the leading slash was a problem?
    it 'is the index file in the root path, without a leading slash' do
      expect(index.path).to eq(expected_path)
    end
  end

  # TODO: Test the methods inherited from Source::FileBase too.
  # include_context 'acts like a source file'

  # TODO: Should this actually be an empty string?
  describe '#relative_dir_path' do
    it 'is the root path, without a leading slash' do
      expect(index.relative_dir_path).to eq(described_class::DIR)
    end
  end

  # TODO: Should this actually be an empty string?
  describe '#relative_file_path' do
    include_context 'stub out everything path'

    it 'is the index file in the root path, without a leading slash' do
      expect(index.relative_file_path).to eq(described_class::FILE_NAME)
    end
  end

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
      /#<#{described_class}: path: `#{index.relative_dir_path}`, file_name: `#{index.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(index.inspect).to match(inspect_output_regex)
    end
  end
end

