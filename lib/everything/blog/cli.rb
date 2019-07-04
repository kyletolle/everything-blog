require 'everything/blog'
require 'logger'

module Everything
  class Blog
    class CLI < Thor
      LOGGER_INFO_STARTING = "Generation of blog starting..."
      LOGGER_INFO_COMPLETE = "Generation of blog complete."
      class_option :verbose, type: :boolean, aliases: :v

      desc 'generate', 'generate an HTML site for the blog directory in your everything repo'
      def generate
        logger.info(LOGGER_INFO_STARTING)
        Everything::Blog.new.generate_site
        logger.info(LOGGER_INFO_COMPLETE)
      end

    private

      def logger
        @logger ||= Logger.new($stdout)
          .tap do |l|
            l.level =
              if options[:verbose]
                Logger::INFO
              else
                Logger::ERROR
              end
          end
      end
    end
  end
end

