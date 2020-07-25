require 'spec_helper'

describe Everything::Blog::Source::Stylesheet do
  let(:stylesheet) do
    described_class.new
  end

  describe '#content' do
    let(:expected_stylesheet_content) do
      given_stylesheet_content
    end
    include_context 'with fake stylesheet'

    it 'is the content of the stylesheet file' do
      expect(stylesheet.content).to eq(expected_stylesheet_content)
    end
  end

  describe '#file_name' do
    let(:expected_file_name) { 'style.css' }
    it 'is the default stylesheet name' do
      expect(stylesheet.file_name).to eq(expected_file_name)
    end
  end

  describe '#relative_dir_path' do
    include_context 'stub out everything path'

    it 'is a relative path to the dir, without a leading slash' do
      expect(stylesheet.relative_dir_path).to eq('css')
    end
  end

  describe '#relative_file_path' do
    include_context 'stub out everything path'

    it 'is a relative path to the file, without a leading slash' do
      expect(stylesheet.relative_file_path).to eq('css/style.css')
    end
  end

  # TODO: Make it check the absolute path
  describe '#==' do
    context 'when the other object does not respond to #file_name' do
      let(:other_object) { nil }

      it 'is false' do
        expect(stylesheet == other_object).to eq(false)
      end
    end

    context 'when the other object responds to #file_name' do
      context 'when the other stylesheet has a different file name' do
        let(:other_stylesheet) do
          described_class.new
            .tap do |style|
              def style.file_name
                'another_style.css'
              end
            end
        end

        it 'is false' do
          expect(stylesheet == other_stylesheet).to eq(false)
        end
      end

      context 'when the other stylesheet has the same file_name' do
        let(:other_stylesheet) do
          described_class.new
        end

        it 'is true' do
          expect(stylesheet == other_stylesheet).to eq(true)
        end
      end
    end
  end

  describe '#inspect' do
    include_context 'stub out everything path'

    let(:inspect_output_regex) do
      /#<#{described_class}: path: `#{stylesheet.relative_dir_path}`, file_name: `#{stylesheet.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(stylesheet.inspect).to match(inspect_output_regex)
    end
  end
end

