require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require 'spec_helper'
require './lib/everything/blog/s3_bucket'
require './spec/support/shared'

describe Everything::Blog::S3Bucket do
  include_context 'with fake aws_access_key_id env var'
  include_context 'with fake aws_secret_access_key env var'

  let(:s3_bucket) do
    described_class.new
  end

  describe '#bucket' do
    include_context 'with mock bucket in s3'

    it 'returns a bucket with the name given in the environment variable' do
      expect(s3_bucket.bucket.key).to eq(expected_bucket_name)
    end
  end

  describe '#files' do
    include_context 'with mock bucket in s3'

    let(:expected_file_name) { 'index.html' }

    before do
      s3_bucket.files.create(
        {
          key: expected_file_name,
          body: '<html></html>'
        }
      )
    end

    after do
      s3_bucket.files.each(&:destroy)
      s3_bucket.bucket.destroy
    end

    it 'returns the expected number of files in the bucket' do
      expect(s3_bucket.files.reload.count).to eq(1)
    end

    it 'includes the files existing in the bucket' do
      expect(s3_bucket.files.reload.map(&:key)).to include(expected_file_name)
    end
  end

  describe '#s3_connection' do
    it 'is a connection to s3' do
      expect(s3_bucket.s3_connection).to respond_to(:get_bucket)
    end
  end
end

