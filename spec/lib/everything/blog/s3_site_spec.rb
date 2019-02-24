require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require 'spec_helper'
require './lib/everything/blog/s3_site'

describe Everything::Blog::S3Site do
  describe '.ToRemoteFile' do
    let(:remote_file) do
      described_class.ToRemoteFile(given_output_file)
    end

    context 'with no output file' do
      let(:given_output_file) do
        'Not a file at all'
      end

      it 'raises the correct error and message' do
        expect { remote_file }.to raise_error(
          Everything::Blog::Remote::NoRemoteFileTypeFound,
          /No .* Remote class found .*String/
        )
      end
    end
  end
end
