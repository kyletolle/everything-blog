require_relative 'file_base'

module Everything
  class Blog
    module Output
      class Stylesheet < Everything::Blog::Output::FileBase
        include Everything::Logger::LogIt

        def initialize(source_file)
          super

          debug_it("Using output stylesheet: #{inspect}")
        end

        def file_name
          source_file.file_name
        end
      end
    end
  end
end

