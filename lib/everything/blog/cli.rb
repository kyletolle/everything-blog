require 'everything/blog'
require 'logger'

module Everything
  class Blog
    class CLI < Thor
      class_option :verbose, type: :boolean, aliases: :v
      class_option :debug, type: :boolean, aliases: :d

      LOGGER_FORMATTER =  proc { |severity, datetime, progname, msg|
        "#{datetime}: #{msg}\n"
      }

      desc 'generate', 'generate an HTML site for the blog directory in your everything repo'
      def generate
        blog.generate_site
      end

    private

      def blog
        Everything::Blog
          .new(logger: logger)
        # TODO: It might still make sense to create the logger here and pass it
        # down. That way the blog class isnt' responsible for the logging setup.
        # Perhaps we should create our own class that inherits from logger? That
        # might make even more sense if we want to change what the log formatter
        # is depending on the log level.
      end

      def logger
        # TODO: Should we use a custom formatter like described at:
        # https://ruby-doc.org/stdlib-2.6.3/libdoc/logger/rdoc/Logger.html
        # This would allow us to customize the output a bit, so we could include
        # potentially the class name of what's running. Maybe the formatter
        # changes depending on whether it's verbose or debugging output!?
        @logger ||= Logger.new($stdout)
          .tap do |l|
            l.level = log_level
            l.formatter = LOGGER_FORMATTER
          end
      end

      def log_level
        if options[:debug]
          Logger::DEBUG
        elsif options[:verbose]
          Logger::INFO
        else
          Logger::ERROR
        end
      end
    end
  end
end

