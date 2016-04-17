# TODO: Delete this class.
require_relative './to_html/output'
require_relative './to_html/template'

module Everything
  module Blog
    class ToHtml
      using Everything::AddWriteHtmlToToPieceRefinement

      def initialize(post)
        @post = post
      end

      def convert
        output = Output.new(post.name)

        def post.sub_piece_header_markdown
          "[#{title}](/)"
        end

        def post.piece_dir_name
          ''
        end

        post.write_html_to(output)

        output.save
      end

    private

      attr_reader :post
    end
  end
end

