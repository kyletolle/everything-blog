require 'kramdown'
require 'fileutils'

module Everything
  class Blog
    module Source
      class FileBase
        def relative_dir_path
          # We can use an approach like the one here: http://stackoverflow.com/questions/11471261/ruby-how-to-calculate-a-path-relative-to-another-one
          @relative_dir_path ||= File.dirname(relative_file_path)
        end

        def relative_file_path
          @relative_file_path ||= Pathname.new(source_file_path)
            .sub(base_source_dir_path, '')
            .to_s
        end

        def content
          raise NotImplementedError
        end

        def should_generate_output?
          # Override this in sub classes to add some smarts as to whether the
          # file should be generated.
          true
        end

        def file_name
          raise NotImplementedError
        end

      private

        def base_source_dir_path
          Fastenv.everything_path
        end

        def base_source_pathname
          @base_source_pathname ||= Pathname.new base_source_dir_path
        end

        def source_file_path
          File.join(base_source_dir_path, file_name)
        end
      end
    end
  end
end
