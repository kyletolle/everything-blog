require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/posts_finder'
# require './spec/support/shared'
require './spec/support/post_helpers'
require 'fakefs/spec_helpers'

describe Everything::Blog::Source::PostsFinder do
  include FakeFS::SpecHelpers

  let(:posts_finder) do
    described_class.new
  end

  describe '#posts' do
    before do
      FakeFS.activate!

      FileUtils.mkdir_p(Everything::Blog::Source.absolute_path)
    end

    after do
      FakeFS.deactivate!
    end

    context 'where there are no posts' do
      it 'is an empty array' do
        expect(posts_finder.posts).to eq([])
      end
    end

    context 'where there are posts' do
      include PostHelpers

      context 'where none are public' do
        before do
          create_post('some-title', 'Some Title', 'This is the body')
        end

        it 'is an empty array' do
          expect(posts_finder.posts).to eq([])
        end
      end

      context 'where some are public' do
        context 'where one piece has created_at timestamp' do
          context 'and the other has created_at timestamp' do
            it 'returns the most recent post first'
          end

          context 'and the other has wordpress post_date timestamp' do
            it 'returns the most recent post first'
          end
        end

        context 'where one piece has wordpress post_date timestamp' do
          context 'and the other has created_at timestamp' do
            it 'returns the most recent post first'
          end

          context 'and the other has wordpress post_date timestamp' do
            it 'returns the most recent post first'
          end
        end
      end
    end
  end
end

