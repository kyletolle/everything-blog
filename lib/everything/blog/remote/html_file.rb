require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class HtmlFile < Everything::Blog::Remote::FileBase
        include Everything::Logger::LogIt

        def initialize(output_file)
          super

          debug_it("Using remote html file: #{inspect}")
        end

        HTML_CONTENT_TYPE = 'text/html'

        def content
          output_file.content
        end

        def content_type
          HTML_CONTENT_TYPE
        end
      end
    end
  end
end
