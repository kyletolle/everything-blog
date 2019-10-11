module Everything
  class Blog
    class Logger
      class Verbose < Everything::Blog::Logger::Base
        def initialize(logdev, progname: nil)
          super
          self.level = ::Logger::INFO
        end
      end
    end
  end
end
