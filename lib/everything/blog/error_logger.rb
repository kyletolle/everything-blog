module Everything
  class Blog
    class ErrorLogger < ::Logger
      DATETIME_PROGNAME_MESSAGE_FORMATTER =
        proc { |severity, datetime, progname, msg|
          "#{datetime}: #{progname}: #{msg}\n"
        }

      def initialize(logdev, progname: nil)
        super
        self.level = ::Logger::ERROR
        self.formatter = DATETIME_PROGNAME_MESSAGE_FORMATTER
      end
    end
  end
end
