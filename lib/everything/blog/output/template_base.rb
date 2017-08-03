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

        def template_path
          # TODO: We're getting an error for trying to access a child class'
          # constants. It seems the fix might be wrapping it in a method. For
          # fucks sake, Ruby. Just lemme do it! https://stackoverflow.com/a/9949907/249218
          ::File.join(templates_path, TEMPLATE_NAME)
        end

        def templates_path
          Fastenv.templates_path
        end
      end
    end
  end
end
