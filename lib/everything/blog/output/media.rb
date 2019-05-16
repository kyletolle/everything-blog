require_relative 'file_base'

module Everything
  class Blog
    module Output
      class Media < Everything::Blog::Output::FileBase
        def output_file_name
          source_file.file_name
        end

        def content_type
          file_extension_match = source_file.source_file_path
            .match(/\.(jpg|gif|png|mp3)$/)
          file_extension = file_extension_match[1]
          CONTENT_TYPES[file_extension]
        end

      private

        CONTENT_TYPES = {
          'jpg' => 'image/jpeg',
          'gif' => 'image/gif',
          'png' => 'image/png',
          'mp3' => 'audio/mpeg'
        }
      end
    end
  end
end
