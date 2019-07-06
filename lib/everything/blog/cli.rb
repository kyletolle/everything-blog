module Everything
  class Blog
    class CLI < Thor
      class_option :verbose, type: :boolean, aliases: :v
      class_option :debug, type: :boolean, aliases: :d

      desc 'generate', 'generate an HTML site for the blog directory in your everything repo'
      def generate
        blog.generate_site
      end

    private

      def blog
        Everything::Blog.new(blog_options)
      end

      def blog_options
        if options[:debug]
          options.slice('debug')
        else
          options.slice('verbose')
        end
      end
    end
  end
end

