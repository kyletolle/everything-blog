require 'kramdown'
require 'forwardable'

module Everything
  class Blog
    class Post
      extend Forwardable

      def initialize(post_name)
        @post_name = post_name
      end

      def created_at
        timestamp_to_use = piece.metadata['created_at'] || piece.metadata['wordpress']['post_date']
        Time.at(timestamp_to_use)
      end

      def created_on
        # Formatted like: June 24, 2016
        created_at.strftime('%B %d, %Y')
      end

      def created_on_iso8601
        # Formatted like: 2016-06-24
        created_at.strftime('%F')
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

      def media_glob
        File.join(piece.full_path, '*.{jpg,png,gif,mp3}')
      end

      def piece
        @piece ||= Everything::Piece.find_by_name_recursive(post_name)
      end

      def_delegators :piece, :name, :title, :body

    private

      attr_reader :post_name
    end
  end
end
