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
        attr_accessor :logger

        def initialize(logger)
          @logger = logger
        end

        def files
          #TODO: Also test memoization, and running compact
          # TODO: Want to only include the index and stylesheet if those pages
          # have changed and need to be regenerated?
          @files ||=
            [ blog_index, stylesheet ]
            .concat(pages)
            .concat(media_for_posts)
            # .compact
          # TODO: Add a tap for logging how many files there are and each of
          # their paths?
          # .tap{|o| puts "Blog: Number of source files: #{o.count}" }
          # .tap{|o| puts 'Blog: Source files'; puts o}
        end

      private

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
