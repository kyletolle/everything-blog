require_relative 'file_base'
require_relative '../post'
require_relative '../source'

module Everything
  class Blog
    module Source
      class Page < FileBase
        include Everything::Logger::LogIt

        attr_reader :post

        def initialize(post)
          @post = post

          debug_it("Using source page: #{inspect}")
        end

        def content
          post.body
        end

        def file_name
          post.piece.content.file_name
        end

        # TODO: Eventually this should only call a method on the page itself,
        # not the page's post.
        def ==(other)
          return false unless other.respond_to?(:post)

          self.post.piece.full_path == other.post.piece.full_path
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
