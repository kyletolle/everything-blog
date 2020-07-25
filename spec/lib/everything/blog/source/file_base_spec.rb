require 'spec_helper'

describe Everything::Blog::Source::FileBase do
  let(:file_base_instance) do
    described_class.new
  end

  describe '#content' do
    context 'when the class is used without going through a child class' do
      subject { file_base_instance.content }

      it 'raises a NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end
  end

  describe '#file_name' do
    context 'when the class is used without going through a child class' do
      subject { file_base_instance.file_name }

      it 'raises a NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end
  end

  describe '#inspect' do
    include_context 'stub out everything path'

    before do
      allow(file_base_instance)
        .to receive(:file_name)
        .and_return("/a/fake/file/name/for/inspect.md")
    end
    let(:inspect_output_regex) do
      /#<#{described_class}: path: `#{file_base_instance.relative_dir_path}`, file_name: `#{file_base_instance.file_name}`>/
    end

    it 'returns a shorthand format with class name and file name' do
      expect(file_base_instance.inspect).to match(inspect_output_regex)
    end
  end
end
