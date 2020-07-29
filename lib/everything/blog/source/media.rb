require_relative 'file_base'
require_relative '../source'

module Everything
  class Blog
    module Source
      class Media < FileBase
        include Everything::Logger::LogIt

        attr_reader :source_file_path

        def initialize(source_file_path)
          @source_file_path = source_file_path

          debug_it("Using source media: #{inspect}")
        end

        def absolute_dir
          # TODO: Make this a Pathname like I did in everything-core
          Pathname.new(File.dirname(source_file_path))
        end

        def absolute_path
          Pathname.new(source_file_path)
        end

        def content
          File.binread(source_file_path)
        end

        def dir
          media_absolute_pathname = Pathname.new(
            absolute_dir
          )
          media_absolute_pathname
            .relative_path_from(Everything::Blog::Source.absolute_pathname)
            .to_path
        end

        def file_name
          File.basename(source_file_path)
        end

        def ==(other)
          return false unless other.respond_to?(:source_file_path)

          self.source_file_path == other.source_file_path
        end

      private

        def base_source_dir_path
          Everything::Blog::Source.absolute_path
        end
      end
    end
  end
end
