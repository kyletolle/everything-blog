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

        def inspect
          "#<#{self.class}: remote_key: `#{remote_key}`>"
        end

        def local_file_is_different?
          remote_file&.etag != content_hash
        end

        def send
          if remote_file_does_not_exist?
            debug_it("Creating remote file for #{inspect}")
            create_remote_file
          elsif local_file_is_different?
            debug_it("Updating remote file for #{inspect}")
            update_remote_file
          else
            debug_it("Doing nothing with remote file for #{inspect}")
          end
        end

        def remote_file_does_not_exist?
          remote_file.nil?
        end

        def remote_file
          @remote_file ||= s3_bucket
            .tap{|b| debug_it("Using S3 bucket: #{b}") }
            &.files
            .tap{|f| debug_it("Working with these files: #{f}") }
            &.head(remote_key)
            .tap{|rf| debug_it("Getting head of remote file: #{rf}") }
        end

        def remote_key
          @remote_key ||= output_file.path.to_s
            .tap{|rk| debug_it("Trying to read remote key: #{rk}") }
        end

      private

        def create_remote_file
          s3_bucket
            .tap{|b| debug_it("Creating in S3 bucket: #{b}") }
            &.files
            .tap{|f| debug_it("Creating with these files: #{f}") }
            &.create(
              key: remote_key,
              body: content,
              content_type: content_type
            )
            .tap{|f| debug_it("Created this file: #{f}") }
        end

        def update_remote_file
          existing_file = s3_bucket.files.get(remote_key)
          existing_file.body = content
          existing_file.save
        end

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

