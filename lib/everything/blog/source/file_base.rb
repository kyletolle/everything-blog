require 'kramdown'
require 'fileutils'

module Everything
  class Blog
    module Source
      class FileBase
        # TODO: Can we take some hints from the ruby File class and use the same
        # methods they do? basename, pathname, absolute_path, etc?
        # http://ruby-doc.org/core-2.4.1/File.html
        # And for joining paths with others, we can use File.expand_path. So we
        # shouldn't probably need to have this relative_file_path and
        # base_source_dir_path and stuff.
        def relative_dir_path
          # We can use an approach like the one here: http://stackoverflow.com/questions/11471261/ruby-how-to-calculate-a-path-relative-to-another-one
          @relative_dir_path ||= File.dirname(relative_file_path)
        end

        def relative_file_path
          @relative_file_path ||= Pathname.new(source_file_path)
            .sub(base_source_dir_path, '')
            .to_s
            .delete_prefix('/')
            # .tap{|fp| puts "SOURCE RELATIVE FILE PATH: #{fp}"}
        end

        def content
          raise NotImplementedError
        end

        def file_name
          raise NotImplementedError
        end

        def inspect
          "#<#{self.class}: file_name: `#{file_name}`>"
        end

      private

        # TODO: Move this into its own Source class/module. It makes sense to
        # have it in its own location.
        def base_source_dir_path
          Everything.path
        end

        # TODO: Do we want to add and use a method like this?
        # def base_source_pathname
        #   @base_source_pathname ||= Pathname.new base_source_dir_path
        # end

        def source_file_path
          File.join(base_source_dir_path, file_name)
        end
      end
    end
  end
end
