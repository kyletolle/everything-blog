require_relative 'file_base'

module Everything
  class Blog
    module Remote
      class BinaryFile < Everything::Blog::Remote::FileBase
        include Everything::Logger::LogIt

        def initialize(output_file)
          super

          debug_it("Using remote binary file: #{inspect}")
        end

        def content
          output_file.output_content
        end

        def content_type
          output_file.content_type
        end
      end
    end
  end
end
