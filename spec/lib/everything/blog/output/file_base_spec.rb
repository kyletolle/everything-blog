require 'spec_helper'

describe Everything::Blog::Output::FileBase do
  describe '.ToOutputFile' do
    include_context 'stub out everything path'

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
      shared_examples 'creates an instance of the proper output class' do
        it 'returns an instance of the proper output class' do
          expect(output_file).to be_a(expected_output_class)
        end

        it 'creates the output object with the source file' do
          expect(output_file.source_file).to eq(given_source_file)
        end
      end

      context 'index' do
        include_context 'with fake source index'

        let(:given_source_file) do
          fake_source_index
        end
        let(:expected_output_class) do
          Everything::Blog::Output::Index
        end
        include_examples 'creates an instance of the proper output class'
      end

      context 'media' do
        include_context 'with fake source media'

        let(:given_source_file) do
          fake_source_media
        end
        let(:expected_output_class) do
          Everything::Blog::Output::Media
        end
        include_examples 'creates an instance of the proper output class'
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
        include_examples 'creates an instance of the proper output class'
      end

      context 'stylesheet' do
        let(:given_source_file) do
          Everything::Blog::Source::Stylesheet.new
        end
        let(:expected_output_class) do
          Everything::Blog::Output::Stylesheet
        end
        include_examples 'creates an instance of the proper output class'
      end
    end
  end

  describe '#inspect' do
    let(:given_source_file) do
      Everything::Blog::Source::Index.new({})
    end
    let(:output_file_base_instance) do
      described_class.new(given_source_file)
    end

    include_context 'stub out everything path'

    before do
      allow(output_file_base_instance)
        .to receive(:file_name)
        .and_return("/a/fake/file/name/for/inspect.md")
    end
    let(:inspect_output_regex) do
      /#<#{described_class}: dir: `#{output_file_base_instance.dir}`, file_name: `#{output_file_base_instance.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(output_file_base_instance.inspect).to match(inspect_output_regex)
    end
  end

  context '#template_klass' do
    context 'when the class is used without going through a child class' do
      include_context 'with fakefs'

      subject { file_base_instance.template_klass }

      let(:file_base_instance) do
        described_class.new(nil)
      end

      it 'raises a NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end
  end
end

