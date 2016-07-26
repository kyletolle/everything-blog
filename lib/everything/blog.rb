# encoding: UTF-8
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

require_relative 'blog/source/site'
require_relative 'blog/output/site'
require_relative 'blog/s3_bucket'
require_relative 'blog/s3_site'

module Everything
  class Blog
    def generate_site
      puts
      puts 'Blog: Generating entire site'
      source_files
        .tap{|o| puts "Blog: Number of source files: #{o.count}" }
        # .tap{|o| puts 'Blog: Source files'; puts o}

      output = Output::Site.new(source_files)
      output.generate

      # S3Site.new(output.output_files).send

      # We may want to send the new media for a piece even though we didn't
      # regenerate the HTML. How would we handle that?

      self
    end

  private

    def source_files
      @source_files ||= source_site.files.compact
    end

    def source_site
      @source_site ||= Source::Site.new
    end
  end
end

# TODO: Remove these files
# require_relative './add_write_html_to_to_piece_refinement'
# require_relative './blog/to_html'

