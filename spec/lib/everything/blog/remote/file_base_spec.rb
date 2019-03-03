require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/remote/file_base'

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
end
