require_relative 'file_base'
require_relative '../source'

module Everything
  class Blog
    module Source
      class Media < FileBase
        attr_reader :source_file_path

        def initialize(source_file_path)
          @source_file_path = source_file_path
        end

        def content
          File.binread(source_file_path)
        end

        def file_name
          File.basename(source_file_path)
        end

        def ==(other)
          return false unless other.respond_to?(:source_file_path)

          self.source_file_path == other.source_file_path
        end

        def to_s
          "#<#{self.class.to_s}: file_name: `#{file_name}`>"
        end

      private

        def base_source_dir_path
          Everything::Blog::Source.absolute_path
        end
      end
    end
  end
end
