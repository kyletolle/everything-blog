require 'spec_helper'

describe Everything::Blog::Source do
  describe '.absolute_dir' do
    include_context 'stub out everything path'

    let(:expected_absolute_dir) do
      Pathname.new('/fake/everything/path/blog')
    end

    it 'is the absolute blog dir' do
      expect(described_class.absolute_dir).to eq(expected_absolute_dir)
    end
  end

  describe '.dir' do
    let(:expected_dir) { Pathname.new('blog') }

    it 'is the blog dir' do
      expect(described_class.dir).to eq(expected_dir)
    end
  end
end

