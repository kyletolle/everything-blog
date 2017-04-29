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

      private

        def source_file_path
          File.join('css', file_name)
        end

        #TODO: I could see this using the follwing instead:
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
