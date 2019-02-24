require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class StylesheetFile < Everything::Blog::Remote::FileBase
        def initialize(file)
          @file = file
        end

        def content
          file.content
        end

        def content_type
          'text/css'
        end
      end
    end
  end
end
