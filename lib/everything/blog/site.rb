require 'everything/blog/site/page'
require 'everything/blog/site/index'
require 'everything/blog/site/media'
require 'Everything/blog/site/css'

module Everything
  class Blog
    class Site
      def self.blog_html_path
        Fastenv.blog_html_path
      end

      def create_index_page(page_names_and_titles)
        index = Index.new(page_names_and_titles)
        index.save_file
        index
      end

      def create_css_file
        css = Css.new
        css.save_file
        css
      end

      def should_generate_page?(post)
        FileUtils.mkdir_p(self.class.blog_html_path)

        page = Page.new(post)

        return true unless ::File.exist?(page.page_file_path)

        page_mtime = ::File.mtime(page.page_file_path)

        markdown_mtime = ::File.mtime(post.piece.full_path)

        markdown_mtime > page_mtime
      end

      def create_post_page(post, post_content_html)
        FileUtils.mkdir_p(self.class.blog_html_path)

        page = Page.new(post, post_content_html)
        page.save_file

        page
      end

      def add_media_to_post(post_name, media_paths)
        FileUtils.mkdir_p(self.class.blog_html_path)

        media_paths.map do |media_path|
          media = Media.new(post_name, media_path)
          media.save_file

          media
        end
      end
    end
  end
end
