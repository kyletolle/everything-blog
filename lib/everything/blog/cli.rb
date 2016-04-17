require 'everything/blog'

module Everything
  class Blog
    class CLI < Thor
      desc 'generate', 'generate an HTML site for the blog directory in your everything repo'
      def generate
        Everything::Blog.new.generate_site.send_to_s3
      end
    end
  end
end

