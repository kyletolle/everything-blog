require_relative 'file_base'
require_relative 'index_template'

module Everything
  class Blog
    module Output
      class Index < FileBase
      private

        def template_klass
          IndexTemplate
        end
      end
    end
  end
end
