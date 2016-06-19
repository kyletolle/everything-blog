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
      index = site.create_index_page(public_post_names_and_titles)
      send_page_to_s3(index)

      css = site.create_css_file
      send_file_to_s3(css)

      public_posts.map do |post|
        page = site.create_post_page(post.name, post.content_html)
        send_page_to_s3(page)

        if post.has_media?
          media = site.add_media_to_post(post.name, post.media_paths)
          media.each do |media_item|
            send_media_to_s3(media_item)
          end
        end
      end

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
        .sort do |a,b|
          a_created_at = a.piece.metadata['created_at'] ||
            a.piece.metadata['wordpress']['post_date']
          b_created_at = b.piece.metadata['created_at'] ||
            b.piece.metadata['wordpress']['post_date']

          b_created_at <=> a_created_at
        end
    end

    def public_post_names_and_titles
      {}.tap do |h|
        public_posts.map do |post|
          h[post.name] = post.title
        end
      end
    end

    def files_to_ignore
      %w(. .. .DS_Store)
    end

    def blog_source_path
      ::File.join(Everything.path, 'blog')
    end

    def send_page_to_s3(page)
      s3_site.send_page(page)
    end

    def send_file_to_s3(file)
      s3_site.send_file(file)
    end

    def send_media_to_s3(media)
      s3_site.send_media(media)
    end

    def s3_site
      @s3_site ||= S3Site.new
    end
  end
end

# require_relative './add_write_html_to_to_piece_refinement'
# require_relative './blog/to_html'

