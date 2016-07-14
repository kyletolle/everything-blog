require_relative 'file_base'
require_relative 'index'

module Everything
  class Blog
    module Output
      class Site
        def self.blog_html_path
          Fastenv.blog_html_path
        end

        def initialize(source_files)
          puts 'creating output site'
          @source_files = source_files
        end

        def generate
          puts 'generating output files'
          output_files
            .tap{|o| puts "output files count: #{o.count}"}
            .select(&:should_generate_output?)
            .tap{|o| puts "output files we should generate: #{o.count}" }
            .map(&:save_file)
        end

        def output_files
          @output_files ||= source_files.map do |source_file|
            puts 'mapping source files to output files'
            Output::FileBase.ToOutputFile(source_file)
          end
        end

      private

        attr_reader :source_files
      end
    end
  end
end
