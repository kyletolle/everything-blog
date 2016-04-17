require 'digest'

module Everything
  class Blog
    class S3Site
      def send_page(page)
        key = page_path(page)
        md5 = page_md5(page)

        s3_file = s3_bucket.files.head(key)

        file_does_not_exist = s3_file.nil?
        local_file_is_newer = s3_file.etag != md5
        if file_does_not_exist || local_file_is_newer
          send_file(key, page.full_page_html)
        end
      end

    private

      def s3_bucket
        @s3_bucket ||= S3Bucket.new
      end

      def page_path (page)
        page.relative_path
      end

      def page_md5(page)
        md5.hexdigest(page.full_page_html)
      end

      def md5
        @md5 ||= Digest::MD5.new
      end

      def send_file(key, html)
        s3_bucket.files.create(key: key, body: html)
      end
    end
  end
end
