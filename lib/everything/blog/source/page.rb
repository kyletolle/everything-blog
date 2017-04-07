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

        def base_source_dir_path
          Everything::Blog::Source.path
        end

        def source_file_path
          post.piece.content.file_path
        end
      end
    end
  end
end
