require_relative 'file_base'
require_relative '../post'
require_relative '../source'

module Everything
  class Blog
    module Source
      class Page < Everything::Blog::Source::FileBase
        include Everything::Logger::LogIt

        attr_reader :post

        def initialize(post)
          @post = post

          debug_it("Using source page: #{inspect}")
        end

        def absolute_dir
          @absolute_dir ||= post.piece.absolute_dir
        end

        def absolute_path
          @absolute_path ||= post.piece.content.absolute_path
        end

        def content
          post.body
        end

        def dir
          # Using an approach from https://stackoverflow.com/a/11471495/249218
          @dir ||= absolute_dir
            .relative_path_from(Everything::Blog::Source.absolute_pathname)
        end

        def file_name
          @file_name ||= post.piece.content.file_name
        end

        def path
          @path ||= post.piece.absolute_path
            .relative_path_from(Everything::Blog::Source.absolute_pathname)
        end

        # TODO: Eventually this should only call a method on the page itself,
        # not the page's post.
        def ==(other)
          return false unless other.respond_to?(:post)

          self.post.piece.full_path == other.post.piece.full_path
        end
      end
    end
  end
end

