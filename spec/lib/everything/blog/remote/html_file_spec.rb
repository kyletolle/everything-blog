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
  include_context 'with mock fog'

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

    it "is the output file's output_content" do
      expect(html_file.content).to eq(given_output_file.output_content)
    end
  end

  describe '#content_type' do
    it 'is equal to HTML_CONTENT_TYPE' do
      expect(html_file.content_type).to eq(described_class::HTML_CONTENT_TYPE)
    end
  end

  # TODO: Add specs for this.
  describe '#send'

  describe '#remote_file' do
    subject { html_file.remote_file }

    context 'when the bucket does not exist' do
      it 'is nil' do
        expect(subject).to be_nil
      end
    end

    context 'when the bucket does exist' do
      include_context 'with mock bucket in s3'

      context 'when the remote file does not exist' do
        it 'is nil' do
          expect(subject).to be_nil
        end
      end

      context 'when the remote file exists' do
        include_context 'with fake output index'
        include_context 'with fake html file in s3'

        it 'returns an AWS file' do
          expect(subject).to be_a(Fog::AWS::Storage::File)
        end

        it 'returns a file with matching remote_key' do
          expect(subject.key).to eq(html_file.remote_key)
        end

        it 'calls head to get the file' do
          bucket_double = instance_double(Everything::Blog::S3Bucket)
          allow(html_file)
            .to receive(:s3_bucket)
            .and_return(bucket_double)
          files_double = instance_double(Fog::AWS::Storage::Files)
          allow(bucket_double)
            .to receive(:files)
            .and_return(files_double)
          allow(files_double)
            .to receive(:head)
          subject
          expect(files_double)
            .to have_received(:head)
            .with(html_file.remote_key)
        end
      end
    end
  end

  describe '#remote_key' do
    it "is the output file's relative_file_path without the leading slash" do
      expected_file_key = given_output_file.output_file_name
      expect(html_file.remote_key).to eq(expected_file_key)
    end
  end
end
