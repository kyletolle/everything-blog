require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class BinaryFile < Everything::Blog::Remote::FileBase
        def content
          output_file.media_file
        end

        def content_type
          output_file.content_type
        end

      private

        def content_hash
          md5.hexdigest(output_file.binary_file_data)
        end
      end
    end
  end
end
