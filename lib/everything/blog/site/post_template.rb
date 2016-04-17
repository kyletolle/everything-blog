require 'erb'
require 'tilt'

module Everything
  class Blog
    class Site
      class PostTemplate
        def initialize(page_content_html)
          @page_content_html = page_content_html
        end

        def merge_content_and_template
          Tilt.new(template_path).render do
            page_content_html
          end
        end

      private

        attr_reader :page_content_html

        def template_path
          File.join(templates_path, template_name)
        end

        def templates_path
          Fastenv.templates_path
        end

        def template_name
          'post.html.erb'
        end
      end
    end
  end
end
