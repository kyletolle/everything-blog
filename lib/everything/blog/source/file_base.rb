require 'kramdown'
require 'fileutils'

module Everything
  class Blog
    module Source
      class FileBase
        def content
          raise NotImplementedError
        end

        def file_name
          raise NotImplementedError
        end

        def inspect
          "#<#{self.class}: dir: `#{dir}`, file_name: `#{file_name}`>"
        end

      private

        def source_file_path
          Everything.path.join(file_name)
        end
      end
    end
  end
end
