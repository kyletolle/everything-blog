require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class HtmlFile < Everything::Blog::Remote::FileBase
        HTML_CONTENT_TYPE = 'text/html'

        def content
          output_file.output_content
        end

        def content_type
          HTML_CONTENT_TYPE
        end
      end
    end
  end
end
