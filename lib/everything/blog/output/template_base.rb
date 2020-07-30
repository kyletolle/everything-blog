require 'erb'
require 'pathname'
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

        def inspect
          "#<#{self.class}: template_path: `#{template_path}`, template_name: `#{template_name}`>"
        end

        def merge_content_and_template
          Tilt.new(template_path).render(template_context) do
            content_html
          end
        end

        def template_path
          Everything::Blog::Output.templates_dir.join(template_name)
        end
      end
    end
  end
end
