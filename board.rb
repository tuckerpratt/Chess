require './pieces.rb'
require './output.rb'

class Board
    include Output
    
    attr_reader :grid, :white_pieces, :black_pieces
    attr_accessor :grid, :white_pieces, :black_pieces

    def initialize

        @white_pieces = []
        @black_pieces = []

        @grid = Array.new(8) {Array.new(8) {''}}

        column = 0
        8.times do
            grid[1][column] = Piece.new('white', 'pawn', column, 1)
            column += 1
        end

        column = 0
        8.times do
            grid[6][column] = Piece.new('black', 'pawn', column, 6)
            column += 1
        end

        grid[0][0] = Piece.new('white', 'rook', 0, 0)
        grid[0][7] = Piece.new('white', 'rook', 7, 0)

        grid[0][1] = Piece.new('white', 'knight', 1, 0)
        grid[0][6] = Piece.new('white', 'knight', 6, 0)

        grid[0][2] = Piece.new('white', 'bishop', 2, 0)
        grid[0][5] = Piece.new('white', 'bishop', 5, 0)

        grid[0][3] = Piece.new('white', 'queen', 3, 0)
        grid[0][4] = Piece.new('white', 'king', 4, 0)

        grid[7][0] = Piece.new('black', 'rook', 0, 7)
        grid[7][7] = Piece.new('black', 'rook', 7, 7)

        grid[7][1] = Piece.new('black', 'knight', 1, 7)
        grid[7][6] = Piece.new('black', 'knight', 6, 7)

        grid[7][2] = Piece.new('black', 'bishop', 2, 7)
        grid[7][5] = Piece.new('black', 'bishop', 5, 7)

        grid[7][3] = Piece.new('black', 'queen', 3, 7)
        grid[7][4] = Piece.new('black', 'king', 4, 7)

        for column in grid
            for row in column
                if row.class == Piece
                    if row.color == 'white'
                        white_pieces << row
                    else
                        black_pieces << row
                    end
                end
            end
        end
    end

    def to_s
        <<~BOARD
            #{SQUARE * 23}
            #{COLUMN_HEADING_DIVIDER}
            #{COLUMN_HEADINGS}
            #{COLUMN_HEADING_DIVIDER}
            #{format_row(0)}
            #{ROW_DIVIDER}
            #{format_row(1)}
            #{ROW_DIVIDER}
            #{format_row(2)}
            #{ROW_DIVIDER}
            #{format_row(3)}
            #{ROW_DIVIDER}
            #{format_row(4)}
            #{ROW_DIVIDER}
            #{format_row(5)}
            #{ROW_DIVIDER}
            #{format_row(6)}
            #{ROW_DIVIDER}
            #{format_row(7)}
            #{ROW_DIVIDER}
            #{SQUARE * 23}
        BOARD
      end

end
