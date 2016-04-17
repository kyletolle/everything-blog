require 'everything/blog/site/file'
require 'everything/blog/site/post_template'

module Everything
  class Blog
    class Site
      class Page < File
        def initialize(post_name, page_content_html)
          @post_name = post_name
          @page_content_html = page_content_html
        end

        def save_file
          FileUtils.mkdir_p(page_dir_path)

          super
        end

        def relative_path
          ::File.join(post_name, page_file_name)
        end

        def full_page_html
          @full_page_html ||= PostTemplate
            .new(page_content_html)
            .merge_content_and_template
        end

      private

        attr_reader :post_name, :page_content_html

        def page_dir_path
          ::File.join(Site.blog_html_path, post_name)
        end

        def page_file_path
          ::File.join(page_dir_path, page_file_name)
        end
      end
    end
  end
end
