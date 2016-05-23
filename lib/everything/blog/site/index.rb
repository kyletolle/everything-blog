require 'kramdown'
require 'everything/blog/site/file'
require 'time'

module Everything
  class Blog
    class Site
      class Index < File
        def initialize(page_names)
          @page_names = page_names
        end

        def relative_path
          page_file_name
        end

        def full_page_html
          @full_page_html ||= PostTemplate
            .new(page_content_html)
            .merge_content_and_template
        end

      private

        def page_file_path
          ::File.join(Site.blog_html_path, page_file_name)
        end

        def page_content_html
          Kramdown::Document
            .new(intro_text_markdown + page_links_markdown)
            .to_html
        end

        def intro_text_markdown
<<MD
I've migrated my site from Wordpress to a static HTML site. The biggest
improvement you'll notice is speed. The site will load very quickly, so you can
get to reading immediately.

There are many features this new site does not have. All the content should be
here, however. This is a work in progress, so I'll be enhancing it as times goes
on. I'll improve the layout first, so the reading experience is pleasant. And
I'll move on from there.

I know the site is drastically different now, but this one will be easier for
both you and me in  the long run. Thanks for your support!

MD
        end

        def page_links_markdown
          @page_names.map do |page_name|
            <<MD
- [#{page_name}](/#{page_name}/)
MD
          end.join("\n")
        end
      end
    end
  end
end
