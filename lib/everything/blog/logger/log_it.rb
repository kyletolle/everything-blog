module Everything
  class Blog
    class Logger
      module LogIt
        using Everything::AddLoggerToEverythingRefinement

        def debug_it(message)
          Everything.logger.debug(class_name) { message }
        end

        def error_it(message)
          Everything.logger.error(class_name) { message }
        end

        def info_it(message)
          Everything.logger.info(class_name) { message }
        end

      private

        def class_name
          self.class.to_s
        end
      end
    end
  end
end

