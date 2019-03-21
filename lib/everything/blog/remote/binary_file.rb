require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class BinaryFile < Everything::Blog::Remote::FileBase
        def content
          output_file.output_content
        end

        def content_type
          output_file.content_type
        end
      end
    end
  end
end
