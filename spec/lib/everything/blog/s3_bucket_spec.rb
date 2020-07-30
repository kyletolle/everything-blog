require 'spec_helper'

describe Everything::Blog::S3Bucket do
  include_context 'with mock fog'

  let(:s3_bucket) do
    described_class.new
  end

  describe '#bucket' do
    subject { s3_bucket.bucket }

    context 'when the bucket does not exist' do
      include_context 'with mock s3 bucket deleted'

      let(:expected_bucket_name) do
        Fastenv.aws_storage_bucket
      end

      # TODO: It should create the bucket...
      # TODO: Why is this not working?!
      it 'creates a bucket with the name given in the environment variable' do
        bucket_before = Everything::Blog::S3Bucket.new
          .s3_connection.directories.get(expected_bucket_name)
        expect(bucket_before).to be_nil

        s3_bucket.bucket

        bucket_after = Everything::Blog::S3Bucket.new
          .s3_connection.directories.get(expected_bucket_name)
        expect(bucket_after).not_to be_nil
        bucket_after.destroy
      end

      it 'returns a bucket with the name given in the environment variable' do
        expect(subject.key).to eq(expected_bucket_name)
      end
    end

    context 'when the bucket exists' do
      include_context 'with mock bucket in s3'

      it 'returns a bucket with the name given in the environment variable' do
        expect(subject.key).to eq(expected_bucket_name)
      end

      it 'memoizes the result' do
        expect(subject.object_id).to eq(s3_bucket.bucket.object_id)
      end
    end
  end

  describe '#files' do
    subject { s3_bucket.files }

    context 'when the bucket does not exist' do
      include_context 'with mock s3 bucket deleted'

      it 'is empty' do
        expect(subject).to be_empty
      end
    end

    context 'when the bucket exists' do
      include_context 'with mock bucket in s3'

      context 'and contains no files' do
        it 'is is an empty array' do
          expect(subject).to match_array([])
        end
      end

      context 'when contains files' do
        include_context 'with fake html file in s3'

        it 'returns the expected number of files in the bucket' do
          expect(subject.reload.count).to eq(1)
        end

        it 'includes the files existing in the bucket' do
          expect(subject.reload.map(&:key)).to include(expected_file_name)
        end

        it 'memoizes the result' do
          expect(subject.object_id).to eq(s3_bucket.files.object_id)
        end
      end
    end
  end

  describe '#s3_connection' do
    include_context 'with fake aws env vars'

    subject { s3_bucket.s3_connection }

    it 'is a connection to s3' do
      expect(subject).to respond_to(:get_bucket)
    end
  end
end

