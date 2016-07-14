# TODO: Eventually this page can go away too? Or we rename SourceSite to have
# this name?
require_relative 'site/page'
require_relative 'site/index'
require_relative 'site/media'
require_relative 'site/css'

module Everything
  class Blog
    class Site
      def self.blog_html_path
        Fastenv.blog_html_path
      end
    end
  end
end
