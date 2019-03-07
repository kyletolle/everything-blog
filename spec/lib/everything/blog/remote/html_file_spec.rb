require 'pp' # helps prevent an error like: 'superclass mismatch for class file'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/remote/html_file'
require './lib/everything/blog/output/index'
require './spec/support/shared'

describe Everything::Blog::Remote::HtmlFile do
  # TODO: Add specs for these
  # include_context 'behaves like a Remote::FileBase'
  include_context 'with fake output index'

  let(:html_file) do
    described_class.new(given_output_file)
  end
  let(:given_output_file) do
    fake_output_index
  end

  describe '::HTML_CONTENT_TYPE' do
    it 'is text/html' do
      expect(described_class::HTML_CONTENT_TYPE).to eq('text/html')
    end
  end

  describe '#initialize' do
    it 'sets the output_file to the given output file' do
      expect(html_file.output_file).to eq(given_output_file)
    end
  end

  describe '#content' do
    before do
      allow(given_output_file)
        .to receive(:output_content)
        .and_return("This content's completely fake and should not be trusted.")
    end

    it "is the output file's content" do
      expect(html_file.content).to eq(given_output_file.output_content)
    end
  end

  describe '#content_type' do
    it 'is equal to HTML_CONTENT_TYPE' do
      expect(html_file.content_type).to eq(described_class::HTML_CONTENT_TYPE)
    end
  end

  describe '#send'
end
