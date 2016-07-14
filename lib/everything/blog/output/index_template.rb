require_relative '../site/template'

module Everything
  class Blog
    class Site
      class IndexTemplate < Template
      private

        def template_name
          'index.html.erb'
        end
      end
    end
  end
end
