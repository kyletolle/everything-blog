require_relative 'file_base'

module Everything
  class Blog
    module Source
      class Page < FileBase
        attr_reader :post

        def initialize(post)
          @post = post
        end

        def content
          post.body
        end

        def file_name
          'index.md'
        end

      private

        # TODO: Come up with a better way of doing this. Too hacky.
        # TODO: This is shared with Source::Media.
        def base_source_dir_path
          File.join(super(), 'blog')
        end

        def source_file_path
          post.piece.content.file_path
        end
      end
    end
  end
end
