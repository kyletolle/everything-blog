require 'spec_helper'

describe Everything::Blog::Remote::FileBase do
  context '#content' do
    context 'when the class is used without going through a child class' do
      subject { file_base_instance.content }

      let(:file_base_instance) do
        described_class.new(nil)
      end

      it 'raises a NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end
  end

  context '#content_type' do
    context 'when the class is used without going through a child class' do
      subject { file_base_instance.content_type }

      let(:file_base_instance) do
        described_class.new(nil)
      end

      it 'raises a NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end
  end

  describe '#inspect' do
    let(:given_source_file) do
      Everything::Blog::Source::Index.new({})
    end
    let(:given_output_file) do
      Everything::Blog::Output::Index.new(given_source_file)
    end
    let(:remote_file_base_instance) do
      described_class.new(given_output_file)
    end

    include_context 'stub out everything path'

    before do
      allow(remote_file_base_instance)
        .to receive(:remote_key)
        .and_return("/a/fake/file/name/for/inspect.md")
    end
    let(:inspect_output_regex) do
      /#<#{described_class}: remote_key: `#{remote_file_base_instance.remote_key}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(remote_file_base_instance.inspect).to match(inspect_output_regex)
    end
  end
end
