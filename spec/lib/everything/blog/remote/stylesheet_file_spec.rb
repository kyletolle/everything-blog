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

  describe '#local_file_is_different?' do
    subject { stylesheet_file.local_file_is_different? }

    context 'when the bucket does not exist' do
      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when the bucket does exist' do
      include_context 'with mock bucket in s3'

      context 'when remote file does not exist' do
        it 'is true' do
          expect(subject).to eq(true)
        end
      end

      context 'when remote file does exist' do
        include_context 'with fake output index'
        include_context 'with fake stylesheet file in s3'

        context 'and has a different hash than the current content' do
          before do
            allow(stylesheet_file)
              .to receive(:content_hash)
              .and_return(mock_stylesheet_file.etag.reverse)
          end

          it 'is true' do
            expect(subject).to eq(true)
          end
        end

        context 'and has the same hash as the current content' do
          before do
            allow(stylesheet_file)
              .to receive(:content_hash)
              .and_return(mock_stylesheet_file.etag)
          end

          it 'is false' do
            expect(subject).to eq(false)
          end
        end
      end
    end
  end

  describe '#send'

  describe '#remote_file' do
    subject { stylesheet_file.remote_file }

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
        include_context 'with fake output stylesheet'
        include_context 'with fake stylesheet file in s3'

        it 'returns an AWS file' do
          expect(subject).to be_a(Fog::AWS::Storage::File)
        end

        it 'returns a file with matching remote_key' do
          given_output_file.relative_file_path
          expect(subject.key).to eq(stylesheet_file.remote_key)
        end

        it 'calls head to get the file' do
          bucket_double = instance_double(Everything::Blog::S3Bucket)
          allow(stylesheet_file)
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
            .with(stylesheet_file.remote_key)
        end
      end
    end
  end

  describe '#remote_file_does_not_exist?' do
    subject { stylesheet_file.remote_file_does_not_exist? }

    context 'when remote_file is nil' do
      before do
        allow(stylesheet_file)
          .to receive(:remote_file)
          .and_return(nil)
      end

      it 'is true' do
        expect(subject).to eq(true)
      end
    end

    context 'when remote_file is not nil' do
      include_context 'with fake stylesheet file in s3'

      before do
        allow(stylesheet_file)
          .to receive(:remote_file)
          .and_return(mock_stylesheet_file)
      end

      it 'is false' do
        expect(subject).to eq(false)
      end
    end
  end

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
