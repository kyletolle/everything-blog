require 'kramdown'
require 'fileutils'

module Everything
  class Blog
    module Source
      class FileBase
        # TODO: Can we take some hints from the ruby File class and use the same
        # methods they do? basename, pathname, absolute_path, etc?
        # See source stylesheet spec for an example of the approach.
        # File docs: http://ruby-doc.org/core-2.4.1/File.html
        # And for joining paths with others, we can use File.expand_path. So we
        # shouldn't probably need to have this relative_file_path and
        # base_source_dir_path and stuff.
        def relative_dir_path
          # We can use an approach like the one here: http://stackoverflow.com/questions/11471261/ruby-how-to-calculate-a-path-relative-to-another-one
          # > Pathname.new('/fake/everything/path/css/style.css').relative_path_from(Pathname.new('/fake/everything/path'))
          # => #<Pathname:css/style.css>
          # > Pathname.new('/fake/everything/path/css/style.css').relative_path_from(Pathname.new('/fake/everything/path')).to_path
          # => "css/style.css"
          @relative_dir_path ||= File.dirname(relative_file_path)
        end

        # TODO: Want to get rid of this...
        def relative_file_path
          @relative_file_path ||= source_file_path.to_s
            .sub(Everything::Blog::Source.absolute_path, '')
            .to_s
            .delete_prefix('/')
        end

        def content
          raise NotImplementedError
        end

        def file_name
          raise NotImplementedError
        end

        def inspect
          "#<#{self.class}: path: `#{relative_dir_path}`, file_name: `#{file_name}`>"
        end

      private

        # TODO: Remove this and replace its usages with Everything.path
        def base_source_dir_path
          Everything.path
        end

        def source_file_path
          Everything.path.join(file_name)
        end
      end
    end
  end
end
