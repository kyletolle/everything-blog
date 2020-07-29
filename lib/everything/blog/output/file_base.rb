require_relative '../output'
require 'kramdown'
require 'fileutils'

class Everything::Blog::Output::NoOutputFileTypeFound < StandardError; end

module Everything
  class Blog
    module Output
      class FileBase
        def self.ToOutputFile(source_file)
          # TODO: Could use some metaprogramming to change the Source namespace
          # to Output.
          case source_file
          when Everything::Blog::Source::Index
            Everything::Blog::Output::Index.new(source_file)
          when Everything::Blog::Source::Media
            Everything::Blog::Output::Media.new(source_file)
          when Everything::Blog::Source::Page
            Everything::Blog::Output::Page.new(source_file)
          when Everything::Blog::Source::Stylesheet
            Everything::Blog::Output::Stylesheet.new(source_file)
          else
            raise Everything::Blog::Output::NoOutputFileTypeFound,
              'No corresponding Output class found for source file type ' \
            "`#{source_file.class.name}`."
          end
        end

        attr_reader :source_file

        def initialize(source_file)
          @source_file = source_file
        end

        def inspect
          "#<#{self.class}: path: `#{relative_dir_path}`, output_file_name: `#{output_file_name}`>"
        end

        def output_content
          source_file.content
        end

        def output_dir_path
          File.dirname output_file_path
        end

        def output_file_name
          'index.html'
        end

        def output_file_path
          File.join(
            Everything::Blog::Output.absolute_path,
            relative_dir_path,
            output_file_name
          )
        end

        # TODO: Rename this to just dir
        def relative_dir_path
          source_file.dir.to_s
        end

        def relative_file_path
          source_file
            .path
            .to_s
            .gsub('md', 'html')
        end

        def save_file
          FileUtils.mkdir_p(output_dir_path)

          File.open(output_file_path, file_mode) do |file|
            file.write(output_content)
          end
        end

        def should_generate_output?
          # Override this in sub classes to add some smarts as to whether the
          # file should be generated.
          true
        end

        def template_klass
          raise NotImplementedError
        end

      private

        def content_html
          Kramdown::Document
            .new(source_file.content)
            .to_html
        end

        def template_context
          nil
        end

        def file_type
          :text
        end

        def file_mode
          FILE_MODES[file_type]
        end

        FILE_MODES = {
          text:   'w',
          binary: 'wb'
        }
      end
    end
  end
end

require_relative '../source/index'
require_relative '../source/stylesheet'
require_relative '../source/page'
require_relative '../source/media'
require_relative 'with_template_base'
require_relative 'index'
require_relative 'stylesheet'
require_relative 'page'
require_relative 'media'

