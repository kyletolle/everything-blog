require_relative 'file_base'

module Everything
  class Blog
    module Output
      class Site
        def self.blog_html_path
          Fastenv.blog_html_path
        end

        def initialize(source_files)
          puts
          puts 'Output: Creating site'
          @source_files = source_files
        end

        def generate
          puts 'Output: Generating files'
          output_files
            .tap{|o| puts "Output: Number of output files: #{o.count}"}
            .select(&:should_generate_output?)
            .tap{|o| puts "Output: Number of output files to generate: #{o.count}" }
            .map(&:save_file)
        end

        def output_files
          @output_files ||= begin
            puts 'Output: Mapping source files to output files'
            source_files.map do |source_file|
              Output::FileBase.ToOutputFile(source_file)
            end
          end
        end

      private

        attr_reader :source_files
      end
    end
  end
end
