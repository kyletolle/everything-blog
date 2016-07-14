require 'fileutils'

module Everything
  class Blog
    class Site
      class Media < SourceFile
        def initialize(original_image_path)
          @original_image_path = original_image_path
        end

        def save_file
          puts "We want to make this path: #{output_dir_path}"
          # FileUtils.mkdir_p(output_dir_path)

          puts "We want to create this file: #{output_file_path}"
          # File.open(output_file_path, 'wb') do |file|
          #   file.write(binary_output_content)
          # end
        end

        def binary_output_content
          File.binread(original_image_path)
        end

        def media_file
          File.open(output_file_path)
        end

        def content_type
          file_extension_match = output_file_path.match(/\.(jpg,gif,png,mp3)$/)
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

        attr_reader :original_image_path

        def output_file_name
          File.basename(original_image_path)
        end

        def source_path
          File.dirname(original_image_path)
        end
      end
    end
  end
end
