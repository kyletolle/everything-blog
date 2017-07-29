require_relative 'file_base'

module Everything
  class Blog
    module Output
      class Stylesheet < Everything::Blog::Output::FileBase
      private

        def output_content
          source_file.content
        end

        def output_file_name
          source_file.file_name
        end
      end
    end
  end
end
