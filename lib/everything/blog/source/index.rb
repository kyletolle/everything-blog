require_relative 'file_base'

module Everything
  class Blog
    module Source
      class Index < FileBase
        def initialize(page_names_and_titles)
          @page_names_and_titles = page_names_and_titles
        end

        def content
          page_links_markdown
        end

        def file_name
          ''
        end

      private

        def page_links_markdown
          @page_names_and_titles.map do |page_name, page_title|
            "- [#{page_title}](/#{page_name}/)"
          end.join("\n")
        end
      end
    end
  end
end
