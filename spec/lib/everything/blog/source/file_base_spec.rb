require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/file_base'

describe Everything::Blog::Source::FileBase do
  describe '#content' do
    context 'when the class is used without going through a child class' do
      subject { file_base_instance.content }

      let(:file_base_instance) do
        described_class.new
      end

      it 'raises a NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end
  end

  describe '#file_name' do
    context 'when the class is used without going through a child class' do
      subject { file_base_instance.file_name }

      let(:file_base_instance) do
        described_class.new
      end

      it 'raises a NotImplementedError' do
        expect { subject }.to raise_error(NotImplementedError)
      end
    end
  end
end
