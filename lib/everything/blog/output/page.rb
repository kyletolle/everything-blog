require_relative 'file_base'
require_relative 'with_template_base'
require_relative 'post_template'

module Everything
  class Blog
    module Output
      class Page < Everything::Blog::Output::WithTemplateBase
        include Everything::Logger::LogIt

        def initialize(source_file)
          super

          debug_it("Using output page: #{inspect}")
        end

        def should_generate_output?
          # TODO: Also need to know if the template changed, because we also
          # want to generate in that case too.
          # TODO: Having a way to force regeneration of all pages would also be
          # nice to have.
          markdown_newer_than_output? || metadata_newer_than_output?
        end

        def template_context
          source_file.post
        end

        def template_klass
          Everything::Blog::Output::PostTemplate
        end

      private

        def markdown_newer_than_output?
          content_mtime > output_mtime
        end

        def metadata_newer_than_output?
          metadata_mtime > output_mtime
        end

        def output_mtime
          @output_time ||=
            if absolute_path.exist?
              absolute_path.mtime
            else
              Time.at(0)
            end
        end

        def content_mtime
          @content_mtime ||= source_file.post.piece.content.absolute_path.mtime
        end

        def metadata_mtime
          @metadata_mtime ||= source_file.post.piece.metadata.absolute_path.mtime
        end
      end
    end
  end
end

