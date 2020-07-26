require 'forwardable'
require_relative 'index'
require_relative 'posts_finder'
require_relative 'stylesheet'
require_relative 'page'
require_relative 'media'

module Everything
  class Blog
    module Source
      class Site
        include Everything::Logger::LogIt

        def files
          info_it("Reading blog source files from `#{Everything.path}`")
          # TODO: Also test memoization, and running compact
          # TODO: Want to only include the index and stylesheet if those pages
          # have changed and need to be regenerated?
          @files ||=
            [ blog_index, stylesheet ]
            .concat(pages)
            .concat(media_for_posts)
            .tap do |o|
              info_it("Processing a total of `#{o.count}` source files")
            end
            # .compact
        end

      private

      def class_name
        self.class.to_s
      end

        def blog_index
          Everything::Blog::Source::Index.new(public_post_names_and_titles)
        end

        def posts_finder
          @posts_finder ||= Everything::Blog::Source::PostsFinder.new
        end

        def stylesheet
          Everything::Blog::Source::Stylesheet.new
        end

        def pages
          posts_finder.posts.map do |post|
            Everything::Blog::Source::Page.new(post)
          end
        end

        def media_for_posts
          posts_finder.media_for_posts.map do |media_path|
            Everything::Blog::Source::Media.new(media_path)
          end
        end

        def public_post_names_and_titles
          {}.tap do |h|
            posts_finder.posts.map do |post|
              h[post.name] = post.title
            end
          end
        end
      end
    end
  end
end

