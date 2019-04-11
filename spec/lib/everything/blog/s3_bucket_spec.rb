require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require 'spec_helper'
require './lib/everything/blog/s3_bucket'
require './spec/support/shared'

describe Everything::Blog::S3Bucket do
  include_context 'with fake aws_access_key_id env var'
  include_context 'with fake aws_secret_access_key env var'
  include_context 'with mock fog'

  let(:s3_bucket) do
    described_class.new
  end

  describe '#bucket' do
    subject { s3_bucket.bucket }

    context 'when the bucket does not exist' do
      it 'returns nil' do
        expect(subject).to be_nil
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
    subject { s3_bucket.files}

    context 'when the bucket does not exist' do
      it 'is nil' do
        expect(subject).to be_nil
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
          expect(s3_bucket.files.reload.count).to eq(1)
        end

        it 'includes the files existing in the bucket' do
          expect(s3_bucket.files.reload.map(&:key)).to include(expected_file_name)
        end
      end
    end
  end

  describe '#s3_connection' do
    subject { s3_bucket.s3_connection }

    it 'is a connection to s3' do
      expect(subject).to respond_to(:get_bucket)
    end

    it 'memoizes the result' do
      expect(subject.object_id).to eq(s3_bucket.s3_connection.object_id)
    end
  end
end

