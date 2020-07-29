require_relative 'file_base'

module Everything
  class Blog
    module Source
      class Index < Everything::Blog::Source::FileBase
        include Everything::Logger::LogIt

        DIR = ''
        FILE_NAME = 'index.html'

        def initialize(page_names_and_titles)
          @page_names_and_titles = page_names_and_titles

          debug_it("Using source index: #{inspect}")
        end

        def absolute_dir
          @absolute_dir ||= Everything.path
        end

        def absolute_path
          @absolute_paht ||= absolute_dir.join(file_name)
        end

        def content
          page_links_markdown
        end

        def dir
          @dir ||= Pathname.new(DIR)
        end

        def file_name
          @file_name ||= Pathname.new(FILE_NAME)
        end

        def path
          @path ||= file_name
        end

        def ==(other)
          return false unless other.respond_to?(:content)

          self.content == other.content
        end

      private

        # TODO: It would be nice to have this Markdown link and list generation
        # in its own class.
        def page_links_markdown
          @page_names_and_titles.map do |page_name, page_title|
            # TODO: Add an extra \n to the end of this string to make the list
            # get generated with p tags that contain links, instead of just a
            # list with links.
            # "- [#{page_title}](/#{page_name}/)\n"
            "- [#{page_title}](/#{page_name}/)"
          end.join("\n")
        end
      end
    end
  end
end

