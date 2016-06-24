require 'kramdown'
require 'everything/blog/site/file'
require 'everything/blog/site/index_template'
require 'time'

module Everything
  class Blog
    class Site
      class Index < File
        def initialize(page_names_and_titles)
          @page_names_and_titles = page_names_and_titles
        end

        def relative_path
          page_file_name
        end

        def full_page_html
          @full_page_html ||= IndexTemplate
            .new(page_content_html)
            .merge_content_and_template
        end

      private

        def page_file_path
          ::File.join(Site.blog_html_path, page_file_name)
        end

        def page_content_html
          Kramdown::Document
            .new(page_links_markdown)
            .to_html
        end

        def page_links_markdown
          @page_names_and_titles.map do |page_name, page_title|
            <<MD
- [#{page_title}](/#{page_name}/)
MD
          end.join("\n")
        end
      end
    end
  end
end
