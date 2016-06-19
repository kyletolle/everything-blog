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

      def public?
        return false unless piece && File.exist?(piece.metadata.file_path)

        piece.public?
      end

      def has_media?
        media_paths.any?
      end

      def media_paths
        Dir.glob(media_glob)
      end

      def piece
        @piece ||= Piece.find_by_name_recursive(post_name)
      end

      def_delegators :piece, :name, :title

    private

      attr_reader :post_name

      def media_glob
        File.join(piece.full_path, '*.{jpg,png,gif,mp3}')
      end
    end
  end
end
