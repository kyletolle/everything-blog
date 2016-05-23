module Everything
  class Blog
    class Site
      class Css
        def save_file
          ::File.open(css_file_path, 'w') do |css|
            css.write(css_template_content)
          end
        end

        def relative_path
          css_file_name
        end

        def content
          css_template_content
        end

      private

        def css_file_path
          ::File.join(Site.blog_html_path, css_file_name)
        end

        def css_file_name
          'style.css'
        end

        def css_template_content
          @css_template_content = ::File.read('css/style.css')
        end
      end
    end
  end
end
