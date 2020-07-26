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
          File.join(Everything.path, dir)
        end

        def absolute_path
          File.join(absolute_dir, file_name)
        end

        def content
          @content ||= File.read(source_file_path)
        end

        def dir
          DIR
        end

        def file_name
          FILE_NAME
        end

        def path
          File.join(dir, file_name)
        end

        # TODO: Make it check the absolute path
        def ==(other)
          return false unless other.respond_to?(:file_name)

          self.file_name == other.file_name
        end

      private

        def source_file_path
          File.join('css', file_name)
        end

        #TODO: I could see this using the follwing instead:
        #TODO: And this would apply to other source file types too.
        # def dir
        #   'css'
        # end

        # def file_name
        #   'style.css'
        # end

        # def path
        #   File.join(dir_name, base_name)
        # end

        # def pathname
        #   Pathname.join(path)
        # end

        # def absolute_path
        #   File.join(Everything.path, path)
        # end

        # def absolute_pathname
        #   Everything.pathname.join(pathname)
        # end
      end
    end
  end
end
