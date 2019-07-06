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

    def initialize(options = {})
      @options = options
    end

    def generate_site
      logger.info(LOGGER_INFO_STARTING)
      # puts
      # puts 'Blog: Generating entire site'
      source_files
        # .tap{|o| puts "Blog: Number of source files: #{o.count}" }
        # .tap{|o| puts 'Blog: Source files'; puts o}

      output = Output::Site.new(source_files)
      output.generate

      Everything::Blog::S3Site.new(output.output_files).send_remote_files

      # TODO: We may want to send the new media for a piece even though we
      # didn't regenerate the HTML. How would we handle that?

      logger.info(LOGGER_INFO_COMPLETE)

      self
    end

    def logger
      @logger ||=
          if options[:debug]
            Everything::Blog::DebugLogger.new($stdout)
          elsif options[:verbose]
            Everything::Blog::VerboseLogger.new($stdout)
          else
            Logger.new($stdout, level: Logger::ERROR)
          end
    end

    def source_files
      @source_files ||= source_site.files.compact
    end

  private

    def source_site
      @source_site ||= Source::Site.new
    end
  end
end

# TODO: Remove these files
# require_relative './add_write_html_to_to_piece_refinement'
# require_relative './blog/to_html'

