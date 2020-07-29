require 'spec_helper'
require './spec/support/post_helpers'

describe Everything::Blog::Source::PostsFinder do
  include PostHelpers

  include_context 'stub out everything path'

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
          create_post('some-title')
          create_post('another-title')
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

        let(:newer_date) do
          '2018-04-21'
        end
        let(:older_date) do
          '2018-01-01'
        end

        context 'where one piece has an older created_on date' do
          before do
            create_post('some-title', is_public: true, created_on: older_date)
          end

          after do
            delete_post('some-title')
          end

          context 'and the other has a newer created_on date' do
            before do
              create_post('another-title',
                          is_public:     true,
                          created_on: newer_date)
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
        create_post('some-title',
                    is_public: true, created_on: '2018-01-01')
        create_post('another-title',
                    is_public: true, created_on: '2018-02-02')
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

        # TODO: Need to clean up how we work with media files in tests.
        it 'returns the media paths by newest post first' do
          expect(posts_finder.media_for_posts).to eq(
            [
              Everything::Blog::Source.absolute_path.join('another-title', 'lala.jpg'),
              Everything::Blog::Source.absolute_path.join('another-title', 'lala.mp3'),
              Everything::Blog::Source.absolute_path.join('some-title', 'lala.jpg'),
              Everything::Blog::Source.absolute_path.join('some-title', 'lala.mp3')
            ]
          )
        end
      end
    end
  end
end
