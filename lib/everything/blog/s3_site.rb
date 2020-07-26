require_relative 'output/stylesheet'
require_relative 'output/index'
require_relative 'output/media'
require_relative 'output/page'
require_relative 'remote/html_file'
require_relative 'remote/stylesheet_file'
require_relative 'remote/binary_file'

module Everything
  class Blog
    class S3Site
      def self.ToRemoteFile(output_file)
        case output_file
        when Everything::Blog::Output::Index
          Everything::Blog::Remote::HtmlFile.new(output_file)
        when Everything::Blog::Output::Media
          Everything::Blog::Remote::BinaryFile.new(output_file)
        when Everything::Blog::Output::Page
          Everything::Blog::Remote::HtmlFile.new(output_file)
        when Everything::Blog::Output::Stylesheet
          Everything::Blog::Remote::StylesheetFile.new(output_file)
        else
          raise Everything::Blog::Remote::NoRemoteFileTypeFound,
            'No corresponding Remote class found for output file type ' \
            "`#{output_file.class.name}`"
        end
      end

      include Everything::Logger::LogIt

      attr_reader :output_files

      def initialize(output_files)
        @output_files = output_files
      end

      def remote_files
        @remote_files ||= output_files.map do |output_file|
          self.class.ToRemoteFile(output_file)
        end
      end

      def send_remote_files
        info_it("Uploading blog output files to S3...")

        remote_files
          .tap do |o|
            info_it("Uploading a total of `#{o.count}` output files")
          end
          .each(&:send)

        info_it("Upload to S3 complete.")
      end
    end
  end
end
