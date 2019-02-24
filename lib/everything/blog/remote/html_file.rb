require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class HtmlFile < Everything::Blog::Remote::FileBase
        def content
          output_file.content
        end

        def content_type
          'text/html'
        end
      end
    end
  end
end
