require_relative 'file_base'
require_relative 'with_template_base'
require_relative 'index_template'

module Everything
  class Blog
    module Output
      class Index < Everything::Blog::Output::WithTemplateBase
        def template_klass
          Everything::Blog::Output::IndexTemplate
        end
      end
    end
  end
end

