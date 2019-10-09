module Everything
  class Blog
    class ErrorLogger < ::Logger
      DATETIME_PROGNAME_MESSAGE_FORMATTER =
        proc { |severity, datetime, progname, msg|
          iso8601_time = datetime.utc.iso8601
          "#{iso8601_time}: #{progname}: #{msg}\n"
        }

      def initialize(logdev, progname: nil)
        super
        self.level = ::Logger::ERROR
        self.formatter = DATETIME_PROGNAME_MESSAGE_FORMATTER
      end
    end
  end
end
