require_relative '../remote'
require_relative '../s3_bucket'
require 'digest'

module Everything
  class Blog
    module Remote
      class FileBase
        attr_reader :output_file

        def initialize(output_file)
          @output_file = output_file
        end

        def content
          raise NotImplementedError
        end

        def content_hash
          md5.hexdigest(content)
        end

        def content_type
          raise NotImplementedError
        end

        def local_file_is_different?
          remote_file&.etag != content_hash
        end

        # def send
        #   if remote_file_does_not_exist? || local_file_is_different?
        #     puts "SENDING TO S3 IS FAKED OUT RIGHT NOW"
        #     # create_remote_file
        #   end
        # end

        def remote_file_does_not_exist?
          remote_file.nil?
        end

        def remote_file
          s3_bucket&.files&.head(remote_key)
        end

        def remote_key
          output_file.relative_file_path
            .tap{|o| o[0] = '' }
        end

      private

        # def create_remote_file
        #   s3_bucket.files.create(
        #     key: remote_key,
        #     body: content,
        #     content_type: content_type
        #   )
        # end

        def s3_bucket
          @s3_bucket ||= Everything::Blog::S3Bucket.new
        end

        def md5
          @md5 ||= Digest::MD5.new
        end
      end
    end
  end
end

