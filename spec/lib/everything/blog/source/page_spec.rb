require './lib/everything/blog/source/page'

describe Everything::Blog::Source::Page do
  let(:post) do
    #TODO:
  end
  let(:page) do
    described.class.new(post)
  end

  describe '#content' do

  end

  describe '#file_name' do
    it 'is post markdown file'
  end
end
