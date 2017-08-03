require_relative 'template_base'

module Everything
  class Blog
    module Output
      class IndexTemplate < Everything::Blog::Output::TemplateBase
        TEMPLATE_NAME = 'index.html.erb'
      end
    end
  end
end
