require 'digest'

module Everything
  class Blog
    class S3Site
      def initialize(pages)
        @pages = pages
      end

      def send_pages
        @pages.each do |page|
          key = page_path(page)
          md5 = page_md5(page)

          s3_file = s3_bucket.files.head(key)

          if s3_file.nil? || s3_file.etag != md5
            send_page(key, page.full_page_html)
          end
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
        Digest::MD5.new
      end

      def send_page(key, html)
        s3_bucket.files.create(key: key, body: html)
      end
    end
  end
end
