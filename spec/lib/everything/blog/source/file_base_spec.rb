require 'spec_helper'

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
