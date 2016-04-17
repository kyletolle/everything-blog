require 'fileutils'

module Everything
  class Blog
    class Site
      class File
        def save_file
          ::File.open(page_file_path, 'w') do |file|
            file.write(full_page_html)
          end
        end

      private

        def page_file_name
          'index.html'
        end
      end
    end
  end
end
