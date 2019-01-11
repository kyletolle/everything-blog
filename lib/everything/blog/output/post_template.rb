require_relative 'template_base'

module Everything
  class Blog
    module Output
      class PostTemplate < TemplateBase
        TEMPLATE_NAME = 'post.html.erb'

        def template_name
          TEMPLATE_NAME
        end
      end
    end
  end
end
