require_relative 'file_base'

module Everything
  class Blog
    module Source
      class Index < Everything::Blog::Source::FileBase
        def initialize(page_names_and_titles)
          @page_names_and_titles = page_names_and_titles
        end

        def content
          page_links_markdown
        end

        def file_name
          ''
        end

        def ==(other)
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
