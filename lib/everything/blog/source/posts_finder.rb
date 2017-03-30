require_relative '../post'

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
          all_post_dirs.map { |post_name| Post.new(post_name) }
        end

        def blog_source_path
          File.join(Everything.path, 'blog')
        end

        def files_to_ignore
          %w(. .. .DS_Store)
        end

        def ordered_public_posts
          public_posts.sort do |a,b|
            a_created_at = a.piece.metadata['created_at'] ||
              a.piece.metadata['wordpress']['post_date']
            b_created_at = b.piece.metadata['created_at'] ||
              b.piece.metadata['wordpress']['post_date']

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