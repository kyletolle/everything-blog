module Everything
  class Blog
    class Logger
      class Error < Everything::Blog::Logger::Base
        def initialize(logdev, progname: nil)
          super
          self.level = ::Logger::ERROR
        end
      end
    end
  end
end
