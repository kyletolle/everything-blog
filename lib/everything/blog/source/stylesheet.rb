require_relative 'file_base'

module Everything
  class Blog
    module Source
      class Stylesheet < Everything::Blog::Source::FileBase
        include Everything::Logger::LogIt

        DIR = 'css'
        FILE_NAME = 'style.css'

        def initialize
          debug_it("Using source stylesheet: #{inspect}")
        end

        def absolute_dir
          # TODO: Alright, this has gotten weird now that this is referencing
          # the Output class. We should move it into the Source class? Or make
          # the Templates class its own thing so .templates_dir can live there?
          @absolute_dir ||= Everything::Blog::Output.templates_dir.join(dir)
        end

        def absolute_path
          @absolute_path ||= absolute_dir.join(file_name)
        end

        def content
          @content ||= absolute_path.read
        end

        def dir
          @dir ||= Pathname.new(DIR)
        end

        def file_name
          @file_name ||= Pathname.new(FILE_NAME)
        end

        def path
          @path ||= dir.join(file_name)
        end

        # TODO: Make it check the absolute path
        def ==(other)
          return false unless other.respond_to?(:file_name)

          self.file_name == other.file_name
        end
      end
    end
  end
end

