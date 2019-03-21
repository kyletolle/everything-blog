require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class StylesheetFile < Everything::Blog::Remote::FileBase
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
