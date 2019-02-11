require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/stylesheet'
require './spec/support/shared'

describe Everything::Blog::Output::Stylesheet do
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

  describe '#output_file_name'
  describe '#output_dir_path'
  describe '#output_file_path'
  describe '#relative_dir_path'
  describe '#save_file'
  describe '#should_generate_output?'

  describe '#source_file' do
    it 'returns the source stylesheet it was created with' do
      expect(stylesheet.source_file).to eq(given_source_stylesheet)
    end
  end
end
