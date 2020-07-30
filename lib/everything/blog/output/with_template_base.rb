require_relative 'file_base'

module Everything
  class Blog
    module Output
      class WithTemplateBase < Everything::Blog::Output::FileBase
        def content
          @content ||= template_klass
            .new(content_html, template_context)
            .merge_content_and_template
        end
      end
    end
  end
end
