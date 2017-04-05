require './lib/everything/blog/source/index'

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

  describe '#content' do
    let(:actual_content) do
      index.content
    end
    let(:actual_content_lines) do
      actual_content.split("\n")
    end

    it 'returns a string with as many lines as the number of pages passed in' do
      actual_line_count = actual_content_lines.count
      expected_line_count = given_page_names_and_titles.count
      expect(actual_line_count).to eq(expected_line_count)
    end

    it 'returns a markdown list of links' do
      expected_markdown_list_and_link_format = /- \[.*\]\(.*\)/
      expect(actual_content_lines)
        .to all(match(expected_markdown_list_and_link_format))
    end

    it 'returns markdown links using page titles as link text and names as link path' do
      given_page_names_and_titles.each
        .with_index do |(page_name, page_title), index|
          actual_content_line = actual_content_lines[index]
          expected_link_format = /\[#{page_title}\]\(\/#{page_name}\/\)/
          expect(actual_content_line).to match(expected_link_format)
        end
    end
  end

  describe '#file_name' do
    it 'is an empty string' do
      expect(index.file_name).to eq('')
    end
  end
end
