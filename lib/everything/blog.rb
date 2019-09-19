# encoding: UTF-8
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

require_relative 'add_pathname_to_everything_refinement'

require_relative 'blog/verbose_logger'
require_relative 'blog/debug_logger'
require_relative 'blog/source'
require_relative 'blog/source/site'
require_relative 'blog/output/site'
require_relative 'blog/s3_bucket'
require_relative 'blog/s3_site'

module Everything
  class Blog
    LOGGER_INFO_STARTING = "Generation of blog starting..."
    LOGGER_INFO_COMPLETE = "Generation of blog complete."

    attr_reader :options

    def self.debug_logger
      Everything::Blog::DebugLogger.new(
        $stdout,
        progname: self.to_s
      )
    end

    def initialize(options = {})
      @options = options
    end

    def generate_site
      logger.info(LOGGER_INFO_STARTING)
      source_files

      output = Everything::Blog::Output::Site.new(source_files)
      output.generate

      Everything::Blog::S3Site.new(output.output_files).send_remote_files

      # TODO: We may want to send the new media for a piece even though we
      # didn't regenerate the HTML. How would we handle that?

      logger.info(LOGGER_INFO_COMPLETE)

      self
    end

    def logger
      @logger ||=
          if options['debug']
            Everything::Blog::DebugLogger.new(
              $stdout,
              progname: self.class.to_s
            )
          elsif options['verbose']
            Everything::Blog::VerboseLogger.new(
              $stdout,
              progname: self.class.to_s
            )
          else
            Logger.new(
              $stdout,
              level: Logger::ERROR,
              progname: self.class.to_s
            )
          end
    end

    def source_files
      @source_files ||= source_site.files.compact
    end

    def source_site
      @source_site ||= Everything::Blog::Source::Site.new(logger)
    end
  end
end

# TODO: Remove these files
# require_relative './add_write_html_to_to_piece_refinement'
# require_relative './blog/to_html'

