require_relative 'file_base'
require_relative '../post'
require_relative '../source'

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
          post.piece.content.file_name
        end

      private

        def base_source_dir_path
          Everything::Blog::Source.absolute_path
        end

        def source_file_path
          post.piece.content.file_path
        end
      end
    end
  end
end
