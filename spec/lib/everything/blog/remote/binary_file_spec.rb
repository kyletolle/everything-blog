require 'pp' # helps prevent an error like: 'superclass mismatch for class file'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/remote/binary_file'
require './lib/everything/blog/output/media'
require './spec/support/shared'

describe Everything::Blog::Remote::BinaryFile do
  include_context 'with fake output media'

  let(:binary_file) do
    described_class.new(given_output_file)
  end
  let(:given_output_file) do
    fake_output_media
  end

  describe '#initialize' do
    it 'sets the output_file to the given output file' do
      expect(binary_file.output_file).to eq(given_output_file)
    end
  end

  describe '#content' do
    before do
      allow(given_output_file)
        .to receive(:output_content)
        .and_return("This content's completely fake and should not be trusted.")
    end

    it "is the output file's output_content" do
      expect(binary_file.content).to eq(given_output_file.output_content)
    end
  end

  describe '#content_type' do
    it "is equal to the output file's content_type" do
      expect(binary_file.content_type).to eq(given_output_file.content_type)
    end
  end

  # TODO: Add specs for this
  describe '#send'
end

