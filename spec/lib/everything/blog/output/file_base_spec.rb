require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/output/file_base'
require 'fakefs/spec_helpers'
require './spec/support/shared'

describe Everything::Blog::Output::FileBase do
  include FakeFS::SpecHelpers

  describe '.ToOutputFile' do
    let(:output_file) do
      described_class.ToOutputFile(given_source_file)
    end

    context 'with no source file' do
      let(:given_source_file) do
        'Not a file at all'
      end

      it 'raises the correct error and message' do
        expect { output_file }.to raise_error(
          Everything::Blog::Output::NoOutputFileTypeFound,
          /No .* Output class found .*String/
        )
      end
    end

    context 'with a source file of type' do
      shared_examples 'creates the proper output class' do
        it 'returns the proper output class' do
          expect(output_file).to be_a(expected_output_class)
        end

        it 'creates the output class with the source file' do
          expect(output_file.source_file).to eq(given_source_file)
        end
      end

      context 'index' do
        let(:given_source_file) do
          Everything::Blog::Source::Index.new({})
        end
        let(:expected_output_class) do
          Everything::Blog::Output::Index
        end
        include_examples 'creates the proper output class'
      end

      context 'stylesheet' do
        let(:given_source_file) do
          Everything::Blog::Source::Stylesheet.new
        end
        let(:expected_output_class) do
          Everything::Blog::Output::Stylesheet
        end
        include_examples 'creates the proper output class'
      end

      context 'page' do
        include_context 'with fake piece'

        let(:given_source_file) do
          Everything::Blog::Source::Page.new(
            Everything::Blog::Post.new(fake_post_name)
          )
        end
        let(:expected_output_class) do
          Everything::Blog::Output::Page
        end
        include_examples 'creates the proper output class'
      end

      context 'media' do
        let(:given_source_file) do
          Everything::Blog::Source::Media.new('')
        end
        let(:expected_output_class) do
          Everything::Blog::Output::Media
        end
        include_examples 'creates the proper output class'
      end
    end
  end

  context '#template_klass' do
    context 'when the class is used without going through a child class' do
      include_context 'with fakefs'

      let(:file_base_instance) do
        Everything::Blog::Output::FileBase.new(nil)
      end

      it 'raises a NotImplementedError' do
        expect { file_base_instance.template_klass }
          .to raise_error(NotImplementedError)
      end
    end
  end
end

