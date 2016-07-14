require 'kramdown'
require 'fileutils'

module Everything
  class Blog
    class Site
      class SourceFile
        def source_relative_path
          @source_relative_path ||= begin
            # We can use an approach like the one here: http://stackoverflow.com/questions/11471261/ruby-how-to-calculate-a-path-relative-to-another-one
            base_source_dir_pathname = Pathname.new base_source_dir_path
            source_pathname = Pathname.new source_path

            base_source_dir_pathname
              .relative_path_from(source_pathname)
              .realdirpath
              .to_s
          end
        end

        def relative_path
          File.join(base_output_dir_path,
                    source_relative_path,
                    output_file_name)
        end

        def save_file
          puts "We want to make this path: #{output_dir_path}"
          # FileUtils.mkdir_p(output_dir_path)

          puts "We want to create this file: #{output_file_path}"
          # File.open(output_file_path, 'w') do |file|
          #   file.write(output_content)
          # end
        end

        def source_content
          raise NotImplementedError
        end

        def should_generate_output?
          # Override this in sub classes to add some smarts as to whether the
          # file should be generated.
          true
        end

      private

        def content_html
          Kramdown::Document
            .new(source_content)
            .to_html
        end

        def output_content
          @output_content ||= template_klass
            .new(content_html, template_context)
            .merge_content_and_template
        end

        def output_file_name
          'index.html'
        end

        def output_file_path
          File.join(base_output_dir_path, source_relative_path)
        end

        def output_dir_path
          File.dirname output_file_path
        end

        def base_source_dir_path
          Fastenv.everything_path
        end

        def base_output_dir_path
          Site.blog_html_path
        end

        def template_context
          nil
        end

        def template_klass
          raise NotImplementedError
        end
      end
    end
  end
end
