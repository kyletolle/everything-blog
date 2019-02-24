require 'digest'
require_relative 'remote/html_file'
require_relative 'remote/stylesheet_file'

module Everything
  class Blog
    class BinaryRemoteFile < RemoteFile
      def initialize(file)
        @file = file
      end

      def content
        file.media_file
      end

      def content_type
        file.content_type
      end

    private

      def content_hash
        md5.hexdigest(file.binary_file_data)
      end
    end

    class S3Site
      def self.ToRemoteFile(file)
        case file
        when Output::Stylesheet
          Everything::Blog::Remote::StylesheetFile.new(file)
        when Output::Index
          Everything::Blog::Remote::HtmlFile.new(file)
        when Output::Media
          BinaryRemoteFile.new(file)
        when Output::Page
          Everything::Blog::Remote::HtmlFile.new(file)
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
