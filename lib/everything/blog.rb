# encoding: UTF-8
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

require 'everything/blog/site'
require 'everything/blog/post'
require 'everything/blog/s3_bucket'
require 'everything/blog/s3_site'
require 'everything/blog/source_site'

module Everything
  class Blog
    def generate_site
      source_files.each do |output_file|
        next unless output_file.should_generate_output?

        output_file.save_file

        # TODO: Separate the generating from the sending.
        S3Site::ToRemoteFile(output_file).send
      end

      # We may want to send the new media for a piece even though we didn't
      # regenerate the HTML. How would we handle that?

      self
    end

  private

    def source_files
      source_site.files
    end

    def source_site
      @source_site ||= SourceSite.new
    end
  end
end

# TODO: Remove these files
# require_relative './add_write_html_to_to_piece_refinement'
# require_relative './blog/to_html'

