require_relative 'file_base'

module Everything
  class Blog
    module Source
      class Stylesheet < Everything::Blog::Source::FileBase
        include Everything::Logger::LogIt

        DIR = 'css'
        FILE_NAME = 'style.css'

        def initialize
          debug_it("Using source stylesheet: #{inspect}")
        end

        def absolute_dir
          Everything.path.join(dir)
        end

        def absolute_path
          absolute_dir.join(file_name)
        end

        def content
          @content ||= File.read(source_file_path)
        end

        def dir
          Pathname.new(DIR)
        end

        def file_name
          Pathname.new(FILE_NAME)
        end

        def path
          dir.join(file_name)
        end

        # TODO: Want to get rid of this...
        def relative_file_path
          @relative_file_path ||= source_file_path.to_s
            .sub(Everything.path.to_s, '')
            .to_s
            .delete_prefix('/')
        end

        # TODO: Make it check the absolute path
        def ==(other)
          return false unless other.respond_to?(:file_name)

          self.file_name == other.file_name
        end

      private

        # TODO: Want to get rid of this...
        def source_file_path
          Everything.path.join(DIR, file_name)
        end
      end
    end
  end
end

