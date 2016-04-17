require 'everything/blog/site/page'
require 'everything/blog/site/index'

module Everything
  class Blog
    class Site
      def self.blog_html_path
        Fastenv.blog_html_path
      end

      def create_index_page(page_names)
        index = Index.new(page_names)
        index.save_file
        index
      end

      def create_post_page(post_name, post_content_html)
        FileUtils.mkdir_p(self.class.blog_html_path)

        page = Page.new(post_name, post_content_html)
        page.save_file

        page
      end
    end
  end
end
