module Everything
  class Blog
    class FogConfig
      def to_h
        {
          provider: provider,
          aws_access_key_id: aws_access_key_id,
          aws_secret_access_key: aws_secret_access_key,
          region: aws_storage_region,
          path_style: path_style
        }
      end

      def provider
        'AWS'
      end

      def aws_access_key_id
        Fastenv.aws_access_key_id
      end

      def aws_secret_access_key
        Fastenv.aws_secret_access_key
      end

      def aws_storage_bucket
        Fastenv.aws_storage_bucket
      end

      def aws_storage_region
        Fastenv.aws_storage_region
      end

      def path_style
        true
      end
    end
  end
end
