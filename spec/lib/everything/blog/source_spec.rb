require 'spec_helper'

describe Everything::Blog::Source do
  describe '.absolute_path' do
    include_context 'stub out everything path'

    let(:expected_absolute_path) { '/fake/everything/path/blog' }

    it 'is the absolute blog dir' do
      expect(described_class.absolute_path).to eq(expected_absolute_path)
    end
  end

  describe '.absolute_pathname' do
    include_context 'stub out everything path'

    let(:expected_absolute_pathname) do
      Pathname.new('/fake/everything/path/blog')
    end

    it 'is the absolute blog pathname' do
      expect(described_class.absolute_pathname)
        .to eq(expected_absolute_pathname)
    end
  end

  describe '.path' do
    let(:expected_path) { 'blog' }

    it 'is the blog path' do
      expect(described_class.path). to eq(expected_path)
    end
  end

  describe '.pathname' do
    let(:expected_pathname) { Pathname.new('blog') }

    it 'is the blog pathname' do
      expect(described_class.pathname).to eq(expected_pathname)
    end
  end
end
