module Everything
  module AddLoggerToEverythingRefinement
    refine Everything.singleton_class do
      def logger
      #   @logger ||= default_logger
      end

      def logger=(value)
        @logger = value
      end

      # def default_logger
      #   Logger.new(
      #     $stdout,
      #     level: Logger::ERROR,
      #     progname: self.class.to_s
      #   )
      # end
    end
  end
end
