require 'pp' # helps prevent an error like: 'superclass mismatch for class file'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/remote/stylesheet_file'
require './spec/support/shared'

describe Everything::Blog::Remote::StylesheetFile do
  include_context 'with fake output stylesheet'

  let(:stylesheet_file) do
    described_class.new(given_output_file)
  end
  let(:given_output_file) do
    fake_output_stylesheet
  end

  describe '::STYLESHEET_CONTENT_TYPE' do
    it 'is text/css' do
      expect(described_class::STYLESHEET_CONTENT_TYPE).to eq('text/css')
    end
  end

  describe '#initialize' do
    it 'sets the output_file to the given output file' do
      expect(stylesheet_file.output_file).to eq(given_output_file)
    end
  end

  describe '#content' do
    before do
      allow(given_output_file)
        .to receive(:output_content)
        .and_return("This content's completely fake and should not be trusted.")
    end

    it "is the output's file's content" do
      expect(stylesheet_file.content).to eq(given_output_file.output_content)
    end
  end

  # TODO: Add specs for these
  describe '#content_type' do
    it 'is equal to STYLESHEET_CONTENT_TYPE' do
      expect(stylesheet_file.content_type)
        .to eq(described_class::STYLESHEET_CONTENT_TYPE)
    end
  end

  describe '#send'
end
