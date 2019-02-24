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
        when Everything::Blog::Output::Stylesheet
          Everything::Blog::Remote::StylesheetFile.new(output_file)
        when Everything::Blog::Output::Index
          Everything::Blog::Remote::HtmlFile.new(output_file)
        when Everything::Blog::Output::Media
          Everything::Blog::Remote::BinaryFile.new(output_file)
        when Everything::Blog::Output::Page
          Everything::Blog::Remote::HtmlFile.new(output_file)
        else
          raise Everything::Blog::Remote::NoRemoteFileTypeFound,
            'No corresponding Remote class found for output file type ' \
            "`#{output_file.class.name}`"
        end
      end

      def initialize(output_files)
        # TODO: Separate the generating from the sending.
        output_files.each do |output_file|
            self.class.ToRemoteFile(output_file).send
          end
      end
    end
  end
end
