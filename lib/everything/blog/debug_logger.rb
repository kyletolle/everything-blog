module Everything
  class Blog
    class DebugLogger < ::Logger
      DATETIME_PROGNAME_MESSAGE_FORMATTER =
        proc { |severity, datetime, progname, msg|
          "#{datetime}: #{progname}: #{msg}\n"
        }

      def initialize(logdev)
        super(logdev)
        self.formatter = DATETIME_PROGNAME_MESSAGE_FORMATTER
      end
    end
  end
end
