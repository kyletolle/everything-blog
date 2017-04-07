require './lib/everything/blog/source'

describe Everything::Blog::Source do
  describe '.path' do
    let(:expected_path) { 'blog' }

    it 'is the blog dir' do
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
