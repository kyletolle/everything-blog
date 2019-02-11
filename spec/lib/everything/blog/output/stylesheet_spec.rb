require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/stylesheet'
require './spec/support/shared'
require './spec/support/post_helpers'

describe Everything::Blog::Output::Stylesheet do
  include_context 'with fake blog path'
  include_context 'stub out blog output path'
  include_examples 'with fake stylesheet'

  let(:given_source_stylesheet) do
    Everything::Blog::Source::Stylesheet.new
  end
  let(:stylesheet) do
    described_class.new(given_source_stylesheet)
  end

  describe '#initialize' do
    it 'takes a source_file argument' do
      expect { stylesheet }.not_to raise_error
    end

    it 'sets the source_file attr' do
      expect(stylesheet.source_file).to eq(given_source_stylesheet)
    end
  end

  describe '#output_file_name' do
    it 'is a style css file' do
      expect(stylesheet.output_file_name).to eq('style.css')
    end
  end

  describe '#output_dir_path' do
    let(:expected_output_dir_path) do
      File.join(fake_blog_output_path, 'css')
    end

    it 'is the full path for the output css dir' do
      expect(stylesheet.output_dir_path).to eq(expected_output_dir_path)
    end
  end

  describe '#output_file_path' do
    let(:expected_output_file_path) do
      File.join(fake_blog_output_path, 'css', stylesheet.output_file_name)
    end

    it 'is the full path for the output file' do
      expect(stylesheet.output_file_path).to eq(expected_output_file_path)
    end
  end
  describe '#relative_dir_path'
  describe '#save_file'

  describe '#should_generate_output?' do
    # TODO: Add detection for whether the Stylesheet should generate or not.
    it 'should be true' do
      expect(stylesheet.should_generate_output?).to eq(true)
    end
  end

  describe '#source_file' do
    it 'returns the source stylesheet it was created with' do
      expect(stylesheet.source_file).to eq(given_source_stylesheet)
    end
  end
end
