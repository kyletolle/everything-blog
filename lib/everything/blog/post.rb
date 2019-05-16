require 'kramdown'
require 'forwardable'

module Everything
  class Blog
    class Post
      extend Forwardable

      def initialize(post_name)
        @post_name = post_name
      end

      # TODO: Need to move to the created_on metadata that now exists in the
      # blog metadata. Move away from all this created_on junk.
      def created_at
        # TODO: If there is no timestamp, perhaps we want to say "Unknown" date?
        # Or should we raise an error if something doesn't have a timestamp?
        # TODO: Can we move to a created_on value in the YAML?
        # TODO: Remember, some posts were written in the east code timezone,
        # some in mountain time, and others in pacific time. This would be
        # simplified if we used the created_on as a date, since that's the
        # output we use anyway.
        timestamp_to_use = piece.metadata['created_at'] || piece.metadata['wordpress']['post_date']
        Time.at(timestamp_to_use)
      end

      def created_on
        # TODO: This is the format we can create from the YAML iso8601 format.
        # Call this method something else. Something like #created_on_human
        # Formatted like: June 24, 2016
        created_at.strftime('%B %d, %Y')
      end

      def created_on_iso8601
        # TODO: This should be the format the YAML contains. This should be
        # called #created_on.
        # Formatted like: 2016-06-24
        created_at.strftime('%F')
      end

      # TODO: This will replace #created_on_iso8601 above.
      def new_created_on
        piece.metadata['created_on']
      end

      # TODO: This will replace #created_on above.
      def new_created_on_human
        new_created_on.strftime('%B %d, %Y')
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
