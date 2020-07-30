require_relative 'fog_config'

module Everything
  class Blog
    class S3Bucket
      include Everything::Logger::LogIt

      def files
        bucket&.files
      end

      def bucket
          @bucket ||= existing_bucket ||
          create_new_bucket

      end

      def s3_connection
        Fog::Storage.new(fog_config.to_h)
      end

    private

      def fog_config
        Everything::Blog::FogConfig.new
      end

      def bucket_name
        fog_config.aws_storage_bucket
      end

      def existing_bucket
        s3_connection.directories.get(bucket_name)
      end

      def create_new_bucket
        s3_connection.directories.create(key: bucket_name)
        s3_connection.directories.get(bucket_name)
      end
    end
  end
end

