require_relative 'source_file'
require_relative 'index_template'

module Everything
  class Blog
    class Site
      class Index < SourceFile
        def initialize(page_names_and_titles)
          @page_names_and_titles = page_names_and_titles
        end

        def source_content
          page_links_markdown
        end

      private

        def template_klass
          IndexTemplate
        end

        def page_links_markdown
          @page_names_and_titles.map do |page_name, page_title|
            <<MD
- [#{page_title}](/#{page_name}/)
MD
          end.join("\n")
        end

        def source_path
          base_output_dir_path
        end
      end
    end
  end
end
