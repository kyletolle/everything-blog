require 'spec_helper'

describe Everything::Blog::S3Site do
  include_context 'with fake output index'
  include_context 'with fake output stylesheet'
  include_context 'with fake output page'

  before :all do
    Fog.mock!
  end

  after :all do
    Fog.unmock!
  end

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
        include_context 'with fake source index'

        let(:given_source_file) do
          fake_source_index
        end
        let(:given_output_file) do
          Everything::Blog::Output::Index.new(given_source_file)
        end
        let(:expected_remote_class) do
          Everything::Blog::Remote::HtmlFile
        end
        include_examples 'creates an instance of the proper remote class'
      end

      context 'media' do
        include_context 'with fake source media'

        let(:given_source_file) do
          fake_source_media
        end
        let(:given_output_file) do
          Everything::Blog::Output::Media.new(given_source_file)
        end
        let(:expected_remote_class) do
          Everything::Blog::Remote::BinaryFile
        end
        include_examples 'creates an instance of the proper remote class'
      end

      context 'page' do
        include_context 'with fake post'

        let(:given_source_file) do
          Everything::Blog::Source::Page.new(fake_post)
        end
        let(:given_output_file) do
          Everything::Blog::Output::Page.new(given_source_file)
        end
        let(:expected_remote_class) do
          Everything::Blog::Remote::HtmlFile
        end
        include_examples 'creates an instance of the proper remote class'
      end

      context 'stylesheet' do
        let(:given_source_file) do
          Everything::Blog::Source::Stylesheet.new
        end
        let(:given_output_file) do
          Everything::Blog::Output::Stylesheet.new(given_source_file)
        end
        let(:expected_remote_class) do
          Everything::Blog::Remote::StylesheetFile
        end
        include_examples 'creates an instance of the proper remote class'
      end
    end
  end

  let(:s3_site) do
    described_class.new(given_output_files)
  end
  let(:given_output_files) do
    [
      fake_output_index,
      fake_output_stylesheet,
      fake_output_page
    ]
  end

  describe '#initialize' do
    subject { s3_site }

    it 'sets the output_files attribute' do
      expect(subject.output_files).to eq(given_output_files)
    end
  end

  describe '#remote_files' do
    subject { s3_site.remote_files }

    it 'has as many items as there are given output files' do
      expect(subject.size).to eq(given_output_files.size)
    end

    it 'is a remote file corresponding to each output file' do
      subject.each do |actual_remote_file|
        expect(actual_remote_file).to be_a(Everything::Blog::Remote::FileBase)
      end
    end

    it 'has remote files that have output files as attributes' do
      subject.each.with_index do |actual_remote_file, index|
        expected_output_file = given_output_files[index]
        expect(actual_remote_file.output_file)
          .to eq(expected_output_file)
      end
    end
  end

  describe '#send_remote_files' do
    include_context 'with mock bucket in s3'

    subject { s3_site.send_remote_files }

    it 'calls send for each remote file' do
      s3_site.remote_files.each do |remote_file|
        expect(remote_file).to receive(:send).once
      end

      subject
    end
  end
end
