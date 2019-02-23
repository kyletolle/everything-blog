require_relative 'fog_config'

module Everything
  class Blog
    class S3Bucket
      def files
        bucket.files
      end

      def bucket
        @bucket ||= s3_connection.directories
          .get(fog_config.aws_storage_bucket)
      end

      def s3_connection
        Fog::Storage.new(fog_config.to_h)
      end

    private

      def fog_config
        FogConfig.new
      end
    end
  end
end
