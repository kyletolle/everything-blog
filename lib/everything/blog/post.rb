require 'kramdown'
require 'forwardable'

module Everything
  class Blog
    class Post
      extend Forwardable

      def initialize(post_name)
        @post_name = post_name
      end

      def content_html
        Kramdown::Document
          .new(piece.raw_markdown)
          .to_html
      end

      def_delegators :piece, :public?, :name

    private

      attr_reader :post_name

      def piece
        @piece ||= Piece.find_by_name_recursive(post_name)
      end
    end
  end
end
