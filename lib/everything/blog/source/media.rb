require 'fileutils'

module Everything
  class Blog
    module Source
      class Media < FileBase
        attr_reader :source_file_path

        def initialize(source_file_path)
          @source_file_path = source_file_path
        end

        def content
          File.binread(source_file_path)
        end

        def file_name
          File.basename(source_file_path)
        end

      private

        def file_type
          :binary
        end

        def base_source_dir_path
          Everything::Blog::Source.path
        end
      end
    end
  end
end
