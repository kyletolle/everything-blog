require 'everything/blog'
require 'logger'

module Everything
  class Blog
    class CLI < Thor
      # TODO: Perhaps this should be in the blog class itself?
      LOGGER_INFO_STARTING = "Generation of blog starting..."
      LOGGER_INFO_COMPLETE = "Generation of blog complete."

      class_option :verbose, type: :boolean, aliases: :v

      desc 'generate', 'generate an HTML site for the blog directory in your everything repo'
      def generate
        # TODO: Perhaps this logging should be in the blog class itself?
        logger.info(LOGGER_INFO_STARTING)

        blog.generate_site

        # TODO: Perhaps this logging should be in the blog class itself?
        logger.info(LOGGER_INFO_COMPLETE)
      end

    private

      def blog
        Everything::Blog
          .new(logger: logger)
        # TODO: We might only pass in a logging level like:
        # def log_level
        #   if options[:debug]
        #     Logger::DEBUG
        #   elsif options[:verbose]
        #     Logger::INFO
        #   else
        #     Logger::ERROR
        #   end
        # end
        #
        # and then pass that log level to the blog object like
        #
        # Everything::Blog.new(log_level: log_level)
      end

      # TODO: Maybe the logger should be pushed down into the blog class and
      # then all this does is pass along whether it's in verbose mode?
      def logger
        @logger ||= Logger.new($stdout)
          .tap do |l|
            l.level =
              if options[:verbose]
                Logger::INFO
              else
                Logger::ERROR
              end

            # TODO: And then we might change how this log level setting works
            # l.level = log_level
          end
      end
    end
  end
end

