# encoding: UTF-8
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

require 'everything/blog/site'
require 'everything/blog/post'
require 'everything/blog/s3_bucket'
require 'everything/blog/s3_site'

module Everything
  class Blog
    def generate_site
      index = site.create_index_page(public_post_names)

      @pages = public_posts.map do |post|
        site.create_post_page(post.name, post.content_html)
      end

      @pages.unshift(index)
      self
    end

    def send_to_s3
      S3Site.new(@pages).send_pages

      self
    end

  private

    def site
      @site = Site.new
    end

    def post_dirs
      Dir.entries(blog_source_path) - files_to_ignore
    end

    def public_posts
      @public_posts ||= post_dirs
        .map { |post_name| Post.new(post_name) }
        .select { |post| post.public? }
    end

    def public_post_names
      public_posts.map { |post| post.name }
    end

    def files_to_ignore
      %w(. .. .DS_Store)
    end

    def blog_source_path
      File.join(Everything.path, 'blog')
    end
  end
end

# require_relative './add_write_html_to_to_piece_refinement'
# require_relative './blog/to_html'

