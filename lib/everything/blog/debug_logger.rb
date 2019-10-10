module Everything
  class Blog
    class DebugLogger < Everything::Blog::Logger::Base
      def initialize(logdev, progname: nil)
        super
        self.formatter = DATETIME_PROGNAME_MESSAGE_FORMATTER
      end
    end
  end
end
