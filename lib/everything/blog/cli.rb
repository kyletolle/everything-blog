require 'everything/blog'
require 'logger'

module Everything
  class Blog
    class CLI < Thor
      class_option :verbose, type: :boolean, aliases: :v

      desc 'generate', 'generate an HTML site for the blog directory in your everything repo'
      def generate
        logger.info("Generation of blog starting...")
        Everything::Blog.new.generate_site
        logger.info("Generation of blog complete.")
      end

    private

      def logger
        @logger ||= Logger.new($stdout)
      end
    end
  end
end

