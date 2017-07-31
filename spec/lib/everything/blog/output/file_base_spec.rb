require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/file_base'

describe Everything::Blog::Output::FileBase do
  describe '.ToOutputFile' do
    let(:to_output_file) do
      described_class.ToOutputFile(given_source_file)
    end

    context 'with no source file' do
      let(:given_source_file) do
        'Not a file at all'
      end

      it 'raises the correct error and message' do
        expect { to_output_file }.to raise_error(
          Everything::Blog::Output::NoOutputFileTypeFound,
          /No .* Output class found .*String/
        )
      end
    end

    context 'with a source file of type' do
      context 'index' do
        let(:source_index_double) do
          double(Everything::Blog::Source::Index)
        end
        let(:given_source_file) { source_index_double }
      end
      context 'stylesheet'
      context 'page'
      context 'media'
    end
  end
end

