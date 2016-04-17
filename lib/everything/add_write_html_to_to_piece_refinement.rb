# TODO: Delete this class.
require 'kramdown'
require_relative './add_pieces_to_piece_refinement'

module Everything
  module AddWriteHtmlToToPieceRefinement
    refine Everything::Piece do
      using Everything::AddPiecesToPieceRefinement

      def write_html_to(output)
        piece_html = Kramdown::Document
          .new("#{total_header_markdown}\n\n#{raw_markdown}")
          .to_html

        output.add_file(piece_dir_name, piece_html)

        public_pieces.each do |sub_piece|
          sub_piece.write_html_to(output)
        end
      end

      def piece_dir_name
        if parent
          File.join(parent.piece_dir_name, name)
        else
          name
        end
      end

      def total_header_markdown
        if parent
          parent.sub_piece_header_markdown
        else
          ''
        end
      end

      def sub_piece_header_markdown
        this_header_markdown = "[#{name}](../)"

        parent_header_markdown =
          if parent
            parent.sub_piece_header_markdown
          else
            ''
          end

        "#{parent_header_markdown} > #{this_header_markdown}"
      end
    end
  end
end
