require 'erb'
require 'tilt'

module Everything
  class Blog
    module Output
      class TemplateBase
        attr_reader :content_html, :template_context

        def initialize(content_html, template_context=nil)
          @content_html = content_html
          @template_context = template_context
        end

        def merge_content_and_template
          Tilt.new(template_path).render(template_context) do
            content_html
          end
        end

        def templates_path
          Fastenv.templates_path
        end

      private

        def template_path
          ::File.join(templates_path, template_name)
        end

        def template_name
          raise NotImplementedError
        end
      end
    end
  end
end
