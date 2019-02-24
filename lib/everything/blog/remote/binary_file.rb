require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class BinaryFile < Everything::Blog::Remote::FileBase
        def initialize(file)
          @file = file
        end

        def content
          file.media_file
        end

        def content_type
          file.content_type
        end

      private

        def content_hash
          md5.hexdigest(file.binary_file_data)
        end
      end
    end
  end
end
