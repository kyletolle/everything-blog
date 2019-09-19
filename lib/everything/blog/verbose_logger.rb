module Everything
  class Blog
    class VerboseLogger < ::Logger
      DATETIME_MESSAGE_FORMATTER =  proc { |severity, datetime, progname, msg|
        "#{datetime}: #{msg}\n"
      }

      def initialize(logdev, progname: nil)
        super
        self.level = ::Logger::INFO
        self.formatter = DATETIME_MESSAGE_FORMATTER
      end
    end
  end
end
