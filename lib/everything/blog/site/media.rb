require 'fileutils'

module Everything
  class Blog
    class Site
      class Media
        def initialize(post_name, original_image_path)
          @post_name = post_name
          @original_image_path = original_image_path
        end

        def save_file
          FileUtils.mkdir_p(page_dir_path)

          ::File.open(media_file_path, 'wb') do |file|
            file.write(binary_file_data)
          end
        end

        def relative_path
          ::File.join(post_name, media_file_name)
        end

        def binary_file_data
          ::File.binread(original_image_path)
        end

        def media_file
          ::File.open(media_file_path)
        end

        def content_type
          file_extension_match = media_file_path.match(/\.(jpg,gif,png,mp3)$/)
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

        attr_reader :post_name, :original_image_path

        def page_dir_path
          ::File.join(Site.blog_html_path, post_name)
        end

        def media_file_path
          ::File.join(page_dir_path, media_file_name)
        end

        def media_file_name
          ::File.basename(original_image_path)
        end
      end
    end
  end
end
