require_relative 'template_base'

module Everything
  class Blog
    module Output
      class IndexTemplate < TemplateBase
      private

        def template_name
          'index.html.erb'
        end
      end
    end
  end
end
