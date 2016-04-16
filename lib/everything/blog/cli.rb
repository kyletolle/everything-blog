require 'everything/blog'

module Everything
  module Blog
    class CLI < Thor
      desc 'generate POST_NAME', 'generate an HTML site for the post POST_NAME in your everything repo'
      def generate(post_name)
        post = Piece.find_by_name_recursive(post_name)

        Everything::Post::ToHtml.new(post).convert
      end
    end
  end
end

