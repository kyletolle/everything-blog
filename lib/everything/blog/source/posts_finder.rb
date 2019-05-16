require_relative '../post'
require_relative '../source'

module Everything
  class Blog
    module Source
      class PostsFinder
        def posts
          # TODO: We could add another line here so that it only returns files
          # that should be modified
          @posts ||= ordered_public_posts
        end

        def media_for_posts
          # TODO: And we could make this always get media for the ordered public
          # posts. And then we could add another line so that it filters out
          # media where the source file hasn't changed since the output file was
          # created.
          @media_for_posts ||= posts
            .map { |post| post.media_paths }
            .flatten
            .compact
        end

      private

        def all_post_dirs
          Dir.entries(blog_source_path) - files_to_ignore
        end

        def all_posts
          all_post_dirs
            .map { |post_name| Everything::Blog::Post.new(post_name) }
        end

        def blog_source_path
          Everything::Blog::Source.absolute_path
        end

        def files_to_ignore
          %w(. .. .DS_Store)
        end

        def ordered_public_posts
          # Note: According to this
          # [post](http://www.virtuouscode.com/2009/10/25/iso8601-dates-in-ruby/)
          # ISO 8601 dates are lexigraphically sortable, which is what we rely
          # on here. It would be possible to get the actual Date objects by
          # doing `require 'date'` and `Date.iso8601('2018-01-01')`
          public_posts.sort do |a,b|
            a_created_at = a.piece.metadata['created_on']
            b_created_at = b.piece.metadata['created_on']

            b_created_at <=> a_created_at
          end
        end

        def public_posts
          all_posts.select { |post| post.public? }
        end
      end
    end
  end
end

