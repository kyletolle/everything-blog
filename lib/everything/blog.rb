# encoding: UTF-8
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

require_relative 'add_pathname_to_everything_refinement'
require_relative 'add_logger_to_everything_refinement'

require_relative 'blog/logger/base'
require_relative 'blog/logger/debug'
require_relative 'blog/logger/error'
require_relative 'blog/logger/verbose'
require_relative 'blog/source'
require_relative 'blog/source/site'
require_relative 'blog/output/site'
require_relative 'blog/s3_bucket'
require_relative 'blog/s3_site'

module Everything
  class Blog
    using Everything::AddLoggerToEverythingRefinement

    LOGGER_INFO_STARTING = "Generation of blog starting..."
    LOGGER_INFO_COMPLETE = "Generation of blog complete."

    attr_reader :options

    def self.debug_logger
      Everything::Blog::Logger::Debug.new(
        $stdout,
        progname: self.to_s
      )
    end

    def self.error_logger
      Everything::Blog::Logger::Error.new(
        $stdout,
        progname: self.to_s
      )
    end

    def self.verbose_logger
      Everything::Blog::Logger::Verbose.new(
        $stdout,
        progname: self.to_s
      )
    end

    def initialize(options = {})
      @options = options

      set_logger
    end

    def generate_site
      info_it(LOGGER_INFO_STARTING)
      source_files

      output = Everything::Blog::Output::Site.new(source_files)
      output.generate

      Everything::Blog::S3Site.new(output.output_files).send_remote_files

      # TODO: We may want to send the new media for a piece even though we
      # didn't regenerate the HTML. How would we handle that?

      info_it(LOGGER_INFO_COMPLETE)

      self
    end

    def info_it(message)
      Everything.logger.info(message)
    end

    def set_logger
      if options['debug']
        use_debug_logger
      elsif options['verbose']
        use_verbose_logger
      else
        use_error_logger
      end
    end

    def source_files
      @source_files ||= source_site.files
    end

    def source_site
      @source_site ||= Everything::Blog::Source::Site.new
    end

    def use_debug_logger
      Everything.logger = self.class.debug_logger
    end

    def use_error_logger
      Everything.logger = self.class.error_logger
    end

    def use_verbose_logger
      Everything.logger = self.class.verbose_logger
    end
  end
end

# TODO: Remove these files
# require_relative './add_write_html_to_to_piece_refinement'
# require_relative './blog/to_html'

