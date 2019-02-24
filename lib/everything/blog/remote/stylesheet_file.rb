require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class StylesheetFile < Everything::Blog::Remote::FileBase
        def content
          output_file.content
        end

        def content_type
          'text/css'
        end
      end
    end
  end
end
