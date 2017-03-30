require 'digest'

module Everything
  class Blog
    class RemoteFile
      def content
        raise NotImplementedError
      end

      def content_type
        raise NotImplementedError
      end

      def send
        if file_does_not_exist || local_file_is_newer
          puts "SENDING TO S3 IS FAKED OUT RIGHT NOW"
          # create_remote_file
        end
      end

    private

      attr_reader :file

      def file_does_not_exist
        remote_file.nil?
      end

      def local_file_is_newer
        remote_file&.etag != content_hash
      end

      def create_remote_file
        s3_bucket.files.create(
          key: remote_key,
          body: content,
          content_type: content_type
        )
      end

      def remote_key
        file.relative_path
          .tap {|o| puts "FILE RELATIVE PATH: #{o}"}
      end

      def content_hash
        md5.hexdigest(content)
      end

      def remote_file
        s3_bucket.files.head(remote_key)
      end

      def s3_bucket
        @s3_bucket ||= S3Bucket.new
      end

      def md5
        @md5 ||= Digest::MD5.new
      end
    end

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
          ToRemoteFile(output_file).send
        end
      end
    end
  end
end
