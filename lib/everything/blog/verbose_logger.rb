module Everything
  class Blog
    class VerboseLogger < Everything::Blog::Logger::Base
      def initialize(logdev, progname: nil)
        super
        self.level = ::Logger::INFO
      end
    end
  end
end
