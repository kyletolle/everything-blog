require 'digest'

module Everything
  class Blog
    class S3Site
      def send_page(page)
        key = file_path(page)
        md5 = page_md5(page)

        s3_file = s3_bucket.files.head(key)

        file_does_not_exist = s3_file.nil?
        local_file_is_newer = s3_file&.etag != md5
        if file_does_not_exist || local_file_is_newer
          send_file_to_s3(key, page.full_page_html)
        end
      end

      def send_file(file)
        key = file_path(file)
        md5 = content_md5(file.content)

        s3_file = s3_bucket.files.head(key)

        file_does_not_exist = s3_file.nil?
        local_file_is_newer = s3_file&.etag != md5
        if file_does_not_exist || local_file_is_newer
          send_file_to_s3(key, file.content)
        end
      end

      def send_media(media)
        key = file_path(media)
        md5 = media_md5(media)

        s3_file = s3_bucket.files.head(key)

        file_does_not_exist = s3_file.nil?
        local_file_is_newer = s3_file&.etag != md5
        if file_does_not_exist || local_file_is_newer
          send_file_to_s3(key, media.media_file)
        end
      end

    private

      def s3_bucket
        @s3_bucket ||= S3Bucket.new
      end

      def file_path(file)
        file.relative_path
      end

      def page_md5(page)
        md5.hexdigest(page.full_page_html)
      end

      def content_md5(content)
        md5.hexdigest(content)
      end

      def media_md5(media)
        md5.hexdigest(media.binary_file_data)
      end

      def md5
        @md5 ||= Digest::MD5.new
      end

      def send_file_to_s3(key, html)
        s3_bucket.files.create(key: key, body: html)
      end
    end
  end
end
