require_relative 'file_base'

module Everything
  class Blog
    module Source
      class Stylesheet < Everything::Blog::Source::FileBase
        def content
          @content ||= File.read(source_file_path)
        end

        def file_name
          'style.css'
        end

        # TODO: Make it check the absolute path
        def ==(other)
          self.file_name == other.file_name
        end

      private

        def source_file_path
          File.join('css', file_name)
        end

        #TODO: I could see this using the follwing instead:
        #TODO: And this would apply to other source file types too.
        # def dirname
        #   'css'
        # end

        # def basename
        #   'style.css'
        # end

        # def path
        #   File.join(dirname, basename)
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
