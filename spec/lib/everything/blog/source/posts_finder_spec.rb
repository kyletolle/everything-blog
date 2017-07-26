require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/posts_finder'
require './spec/support/shared'
require './spec/support/post_helpers'
require 'fakefs/spec_helpers'

describe Everything::Blog::Source::PostsFinder do
  include FakeFS::SpecHelpers

  let(:posts_finder) do
    described_class.new
  end

  describe '#posts' do
    include_context 'with fakefs'
    include_context 'create blog path'

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
          create_post('another-title', 'Another Title', 'This is the body')
        end

        after do
          delete_post('some-title')
          delete_post('another-title')
        end

        it 'is an empty array' do
          expect(posts_finder.posts).to eq([])
        end
      end

      context 'where some are public' do
        shared_examples 'returns the most recent post first' do
          it 'returns the most recent post first' do
            expect(posts_names).to eq(['another-title', 'some-title'])
          end
        end

        let(:posts_names) do
          posts_finder.posts.map(&:name)
        end

        let(:newer_timestamp) do
          Time.now.to_i
        end
        let(:older_timestamp) do
          newer_timestamp - 1
        end

        context 'where one piece has an older created_at timestamp' do
          before do
            create_post('some-title', 'Some Title', 'This is the body',
                        'public' => true, 'created_at' => older_timestamp)
          end

          after do
            delete_post('some-title')
          end

          context 'and the other has a newer created_at timestamp' do
            before do
              create_post('another-title', 'Another Title', 'This is the body',
                          'public' => true, 'created_at' => newer_timestamp )
            end

            after do
              delete_post('another-title')
            end

            include_examples 'returns the most recent post first'
          end

          context 'and the other has a newer wordpress post_date timestamp' do
            before do
              create_post('another-title', 'Another Title', 'This is the body',
                          'public'    => true,
                          'wordpress' => { 'post_date' => newer_timestamp })
            end

            after do
              delete_post('another-title')
            end

            include_examples 'returns the most recent post first'
          end
        end

        context 'where one piece has an older wordpress post_date timestamp' do
          before do
            create_post('some-title', 'Some Title', 'This is the body',
                        'public'    => true,
                        'wordpress' => { 'post_date' => older_timestamp })
          end

          after do
            delete_post('some-title')
          end

          context 'and the other has a newer created_at timestamp' do
            before do
              create_post('another-title', 'Another Title', 'This is the body',
                          'public' => true, 'created_at' => newer_timestamp)
            end

            after do
              delete_post('another-title')
            end

            include_examples 'returns the most recent post first'
          end

          context 'and the other has a newer wordpress post_date timestamp' do
            before do
              create_post('another-title', 'Another Title', 'This is the body',
                          'public'    => true,
                          'wordpress' => { 'post_date' => newer_timestamp})
            end

            after do
              delete_post('another-title')

            end

            include_examples 'returns the most recent post first'
          end
        end
      end
    end
  end
end

