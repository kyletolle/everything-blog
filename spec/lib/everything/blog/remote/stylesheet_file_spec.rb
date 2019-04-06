require 'pp' # helps prevent an error like: 'superclass mismatch for class file'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/remote/stylesheet_file'
require './lib/everything/blog/output/stylesheet'
require './spec/support/shared'

describe Everything::Blog::Remote::StylesheetFile do
  include_context 'with fake output stylesheet'
  include_context 'with mock fog'

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

  describe '#content_hash' do
    subject { stylesheet_file.content_hash }

    let(:md5_double) { instance_double(Digest::MD5) }

    before do
      allow(Digest::MD5)
        .to receive(:new)
        .and_return(md5_double)
      allow(md5_double)
        .to receive(:hexdigest)
    end

    it 'uses the md5 library to do a hexdigest' do
      subject

      expect(md5_double)
        .to have_received(:hexdigest)
        .with(stylesheet_file.content)
    end

    it 'returns the md5 hash' do
      fake_hash = 'defn0tah4sh'

      allow(md5_double)
        .to receive(:hexdigest)
        .and_return(fake_hash)
      expect(subject).to eq(fake_hash)
    end
  end

  describe '#content_type' do
    it 'is equal to STYLESHEET_CONTENT_TYPE' do
      expect(stylesheet_file.content_type)
        .to eq(described_class::STYLESHEET_CONTENT_TYPE)
    end
  end

  # TODO: Add specs for this.
  describe '#send'

  describe '#remote_key' do
    subject { stylesheet_file.remote_key }

    before do
      @initial_remote_key = subject.dup
      stylesheet_file.remote_key
      stylesheet_file.remote_key
      stylesheet_file.remote_key
    end

    it "is the output file's relative_file_path with a leading slash" do
      expected_file_key = given_output_file.relative_file_path
      expect(subject).to eq(expected_file_key)
    end

    it 'returns the same result when called multiple times' do
      expect(stylesheet_file.remote_key).to eq(@initial_remote_key)
    end

    it 'memoizes the result' do
      expect(subject.object_id).to eq(stylesheet_file.remote_key.object_id)
    end
  end
end
