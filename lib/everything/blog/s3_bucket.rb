module Everything
  class Blog
    class S3Bucket
      def files
        bucket.files
      end

      def bucket
        @bucket ||= s3_connection.directories.get(aws_storage_bucket)
      end

      def s3_connection
        Fog::Storage.new(fog_config)
      end

    private

      def fog_config
        {
          provider:              fog_provider,
          aws_access_key_id:     aws_access_key_id,
          aws_secret_access_key: aws_secret_access_key,
          region:                aws_storage_region,
          path_style:            true
        }
      end

      def fog_provider
        'AWS'
      end

      def aws_access_key_id
        Fastenv.aws_access_key_id
      end

      def aws_secret_access_key
        Fastenv.aws_secret_access_key
      end

      def aws_storage_region
        Fastenv.aws_storage_region
      end

      def aws_storage_bucket
        Fastenv.aws_storage_bucket
      end
    end
  end
end
