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

    context 'with an output file of type' do
      shared_examples 'creates an instance of the proper remote class' do
        it 'returns an instance of the proper remote class' do
          expect(remote_file).to be_a(expected_remote_class)
        end

        it 'creates the remote object with the output file' do
          expect(remote_file.output_file).to eq(given_output_file)
        end
      end

      context 'index' do
        let(:given_output_file) do
          Everything::Blog::Output::Index.new({})
        end
        let(:expected_remote_class) do
          Everything::Blog::Remote::HtmlFile
        end
        include_examples 'creates an instance of the proper remote class'
      end

      context 'media' do
        let(:given_output_file) do
          Everything::Blog::Output::Media.new('')
        end
        let(:expected_remote_class) do
          Everything::Blog::Remote::BinaryFile
        end
        include_examples 'creates an instance of the proper remote class'
      end

      context 'page' do
        let(:given_output_file) do
          Everything::Blog::Output::Page.new('')
        end
        let(:expected_remote_class) do
          Everything::Blog::Remote::HtmlFile
        end
        include_examples 'creates an instance of the proper remote class'
      end

      context 'stylesheet' do
        let(:given_output_file) do
          Everything::Blog::Output::Stylesheet.new('')
        end
        let(:expected_remote_class) do
          Everything::Blog::Remote::StylesheetFile
        end
        include_examples 'creates an instance of the proper remote class'
      end
    end
  end
end
