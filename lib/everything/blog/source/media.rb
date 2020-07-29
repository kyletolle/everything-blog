require_relative 'file_base'
require_relative '../source'

module Everything
  class Blog
    module Source
      class Media < Everything::Blog::Source::FileBase
        include Everything::Logger::LogIt

        attr_reader :absolute_path, :source_file_path

        def initialize(absolute_path)
          @source_file_path = absolute_path
          @absolute_path = Pathname.new(absolute_path)

          debug_it("Using source media: #{inspect}")
        end

        def absolute_dir
          absolute_path.dirname
        end

        def content
          absolute_path.binread
        end

        def dir
          absolute_dir
            .relative_path_from(Everything::Blog::Source.absolute_pathname)
        end

        def file_name
          absolute_path.basename
        end

        def ==(other)
          return false unless other.respond_to?(:absolute_path)

          self.absolute_path == other.absolute_path
        end
      end
    end
  end
end
