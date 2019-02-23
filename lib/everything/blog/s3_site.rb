require 'digest'

module Everything
  class Blog
    class HtmlRemoteFile < RemoteFile
      def initialize(file)
        @file = file
      end

      def content
        file.content
      end

      def content_type
        'text/html'
      end
    end

    class StylesheetRemoteFile < RemoteFile
      def initialize(file)
        @file = file
      end

      def content
        file.content
      end

      def content_type
        'text/css'
      end
    end

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
          StylesheetRemoteFile.new(file)
        when Output::Index
          HtmlRemoteFile.new(file)
        when Output::Media
          BinaryRemoteFile.new(file)
        when Output::Page
          HtmlRemoteFile.new(file)
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
