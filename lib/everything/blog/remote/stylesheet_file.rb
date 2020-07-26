require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class StylesheetFile < Everything::Blog::Remote::FileBase
        include Everything::Logger::LogIt

        def initialize(output_file)
          super

          debug_it("Using remote stylesheet file: #{inspect}")
        end

        STYLESHEET_CONTENT_TYPE = 'text/css'

        def content
          output_file.output_content
        end

        def content_type
          STYLESHEET_CONTENT_TYPE
        end
      end
    end
  end
end
