require_relative 'template_base'

module Everything
  class Blog
    module Output
      class PostTemplate < TemplateBase
      private

        def template_name
          'post.html.erb'
        end
      end
    end
  end
end
