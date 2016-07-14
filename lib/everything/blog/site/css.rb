require_relative 'source_file'

module Everything
  class Blog
    class Site
      class Css < SourceFile
        def output_content
          @output_content ||= File.read('css/style.css')
        end

      private

        def output_file_name
          'style.css'
        end

        def source_path
          base_output_dir_path
        end
      end
    end
  end
end
