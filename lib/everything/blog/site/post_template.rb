require_relative '../site/template'

module Everything
  class Blog
    class Site
      class PostTemplate < Template
      private

        def template_name
          'post.html.erb'
        end
      end
    end
  end
end
