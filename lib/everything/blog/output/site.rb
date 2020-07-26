require_relative 'file_base'

module Everything
  class Blog
    module Output
      class Site
        include Everything::Logger::LogIt

        def initialize(source_files)
          @source_files = source_files
        end

        def generate
          info_it("Creating blog output files...")

          output_files
            .tap do |o|
              info_it("Processing a total of `#{o.count}` output files")
            end
            .select(&:should_generate_output?)
            .tap do |o|
              info_it("Generating and saving a total of `#{o.count}` output files")
            end
            .map(&:save_file)

          info_it("Creation of  blog output files complete.")
        end

        def output_files
          @output_files ||= begin
            source_files.map do |source_file|
              # TODO: This feels weird, could I call this method on the source
              # file's class?
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
