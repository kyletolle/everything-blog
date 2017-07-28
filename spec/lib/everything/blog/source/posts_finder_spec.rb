require 'pp' # Helps prevent an error like: 'superclass mismatch for class File'
require 'bundler/setup'
Bundler.require(:default)
require './lib/everything/blog/source/posts_finder'
require 'fakefs/spec_helpers'
require './spec/support/shared'
require './spec/support/post_helpers'

describe Everything::Blog::Source::PostsFinder do
  include FakeFS::SpecHelpers
  include PostHelpers

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

  describe '#media_for_posts' do
    include_context 'with fakefs'
    include_context 'create blog path'

    context 'when there are no public posts' do
      it 'is an empty array' do
        expect(posts_finder.media_for_posts).to eq([])
      end
    end

    context 'when there are public posts' do
      before do
        create_post('some-title', 'Some Title', 'This is the body',
                    'public' => true, 'created_at' => 111)
        create_post('another-title', 'Another Title', 'This is the body',
                    'public' => true, 'created_at' => 121)
      end

      after do
        delete_post('some-title')
        delete_post('another-title')
      end

      context 'that have no media files' do
        it 'is an empty array' do
          expect(posts_finder.media_for_posts).to eq([])
        end
      end

      context 'that each have multiple media files' do
        before do
          create_media_for_post('some-title')
          create_media_for_post('another-title')
        end

        it 'returns the media paths by newest post first' do
          expect(posts_finder.media_for_posts).to eq(
            [
              File.join(Everything::Blog::Source.absolute_path, 'another-title', 'lala.jpg'),
              File.join(Everything::Blog::Source.absolute_path, 'another-title', 'lala.mp3'),
              File.join(Everything::Blog::Source.absolute_path, 'some-title', 'lala.jpg'),
              File.join(Everything::Blog::Source.absolute_path, 'some-title', 'lala.mp3')
            ]
          )
        end
      end
    end
  end
end

