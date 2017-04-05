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
      end
    end
  end
end
