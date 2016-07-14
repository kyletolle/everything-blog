require_relative 'source_file'
require_relative 'post_template'

module Everything
  class Blog
    class Site
      class Page < SourceFile
        def initialize(post)
          @post = post
        end

        def source_content
          post.body
        end

        def should_generate_output?
          markdown_mtime > output_mtime || metadata_mtime > output_mtime
        end

      private

        attr_reader :post

        def template_context
          @post
        end

        def template_klass
          PostTemplate
        end

        def output_mtime
          @output_time ||= File.mtime(output_file_path)
        end

        def markdown_mtime
          @markdown_mtime ||= File.mtime(post.piece.full_path)
        end

        def metadata_mtime
          @metadata_mtime ||= File.mtime(post.metadata.full_path)
        end

        def source_path
          @post.full_path
        end
      end
    end
  end
end
