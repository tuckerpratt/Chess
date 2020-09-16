

class Piece
    attr_reader :type, :has_moved, :color, :position, :directions, :king_attack_path
    attr_accessor :type, :symbol, :position, :has_moved, :king_attack_path

    def initialize(color, type, column, row)
        @color = color
        @type = type
        @has_moved = false
        @position = [column, row]
        @king_attack_path = []

        if color == 'white'
            case @type
            when 'pawn'
                @symbol = "\u265f"
            when 'knight'
                @symbol = "\u265e"
            when 'bishop'
                @symbol = "\u265d"
            when 'rook'
                @symbol = "\u265c"
            when 'queen'
                @symbol = "\u265b"
            when 'king'
                @symbol = "\u265a"
            end
        elsif color == 'black'
            case @type
            when 'pawn'
                @symbol = "\u2659"
            when 'knight'
                @symbol = "\u2658"
            when 'bishop'
                @symbol = "\u2657"
            when 'rook'
                @symbol = "\u2656"
            when 'queen'
                @symbol = "\u2655"
            when 'king'
                @symbol = "\u2654"
            end
        end

        self.get_directions
    end

    def get_directions
        @directions = []

        if @type == 'pawn' && @color == 'white'
            @directions.append([0,1])
            if has_moved == false
                @directions.append([0,2])
            end
        elsif @type == 'pawn' && @color == 'black'
            @directions.append([0,-1])
            if has_moved == false
                @directions.append([0,-2])
            end
        end

        if @type == 'king'
            @directions = [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
        end

        if @type == 'bishop'
            @directions = [[1,1],[1,-1],[-1,1],[-1,-1]] #placeholder for directions it can go
        end

        if @type == 'queen'
            @directions = [[1,1],[1,-1],[-1,1],[-1,-1],[1,0],[0,1],[-1,0],[0,-1]] #placeholder for directions it can go
        end

        if @type == 'knight'
            @directions = [[2,1],[2,-1],[1,2],[-1,2],[-2,1],[-2,-1],[1,-2],[-1,-2]]
        end

        if @type == 'rook'
            @directions = [[1,0],[0,1],[-1,0],[0,-1]]
        end

    end

    def get_binding
        binding
    end
end
