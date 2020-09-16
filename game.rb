require './pieces.rb'
require './output.rb'
require './board.rb'
require 'yaml'

class Game
    attr_reader :board, :white_check, :black_check, :black_king_position, :white_king_position, :stalemate
    
    def initialize
        @board = Board.new
        @current_player = 'white'

        @white_king = board.grid[0][4]
        @black_king = board.grid[7][4]
        @white_check = false
        @black_check = false
        @white_checkmate = false
        @black_checkmate = false
        @stalemate = false
        @move_complete = false


        white_king = board.white_pieces.select {|piece| piece.type == 'king'}
        @white_king_position = white_king[0].position

        black_king = board.black_pieces.select {|piece| piece.type == 'king'}
        @black_king_position = black_king[0].position
    end


    def position_conversion(start)
        real_start = ['','']
        case start[0]
        when "a"
            real_start[0] = 0
        when "b"
            real_start[0] = 1
        when "c"
            real_start[0] = 2
        when "d"
            real_start[0] = 3
        when "e"
            real_start[0] = 4
        when "f"
            real_start[0] = 5
        when "g"
            real_start[0] = 6
        when "h"
            real_start[0] = 7
        else
            real_start[0] = 8
        end

        case start[1]
        when "1"
            real_start[1] = 0
        when "2"
            real_start[1] = 1
        when "3"
            real_start[1] = 2
        when "4"
            real_start[1] = 3
        when "5"
            real_start[1] = 4
        when "6"
            real_start[1] = 5
        when "7"
            real_start[1] = 6
        when "8"
            real_start[1] = 7
        else
           real_start[1] = 8
        end
        return real_start
    end

    def player_turn
        puts "Please select a piece to move by selecting its square (e.g. e6), or type save to save the game and exit, or type exit to exit."
        input = gets.chomp.downcase
        if input == 'save'
            save_game
            exit!
        elsif input == 'exit'
            exit!
        else
            start = position_conversion(input.split(''))
            if start[0] == 8 || start[1] == 8
                return
            elsif board.grid[start[1]][start[0]].class != Piece
                return
            end
        end
        
        if board.grid[start[1]][start[0]].color == @current_player
            puts "Specify where to move the piece (e.g. e7)"
            location = position_conversion(gets.chomp.downcase.split(''))
            if location[0] == 8 || location[1] == 8
                return
            end
            move(start, location)
            if @current_player == "white" && @move_complete == true
                @current_player = "black"
            elsif @current_player == "black" && @move_complete == true
                @current_player = "white"
            end
        else
            puts "Please select one of your pieces"
            return
        end

        puts board.to_s
    end

    def save_game()
        File.open("save_file.yaml", "w") {|file| file.write(YAML::dump(self))}
    end

    

    def legal_moves(piece)
        legal_moves = []
        directions = piece.directions
        original_pos = piece.position
        directions.each do |path|
            pos = original_pos.clone
            while pos[0].between?(0,7) && pos[1].between?(0,7)
                pos[0] += path[0]
                pos[1] += path[1]
                if pos[0].between?(0,7) && pos[1].between?(0,7)
                    if board.grid[pos[1]][pos[0]] == nil
                        break
                    elsif board.grid[pos[1]][pos[0]].class == Piece
                        if board.grid[pos[1]][pos[0]].color != piece.color
                            legal_moves << pos.clone

                            break
                        elsif board.grid[pos[1]][pos[0]].color == piece.color

                            break
                        end
                    elsif board.grid[pos[1]][pos[0]] == ""
                        legal_moves << pos.clone
                    end
                else
                    break
                end
                
                if piece.type == 'knight' || piece.type == 'king'
                    break
                end
            end 
            if piece.type == 'pawn'
                for square in attacking_squares(piece) do
                    attack_square = board.grid[square[1]][square[0]]
                    if attack_square.class == Piece && attack_square.color != piece.color
                        legal_moves << square
                    end
                end
                break   
            end  
            pos = original_pos.clone          
        end
        return legal_moves
    end

    #same thing as legal moves but I'm too dumb to figure out an elegant way to 
    #track attacking same color pieces without moving there. This is basically just
    #for check and checkmate functions

    def attacking_squares(piece) 
        white_king = board.white_pieces.select {|piece| piece.type == 'king'}
        white_king_position = white_king[0].position

        black_king = board.black_pieces.select {|piece| piece.type == 'king'}
        black_king_position = black_king[0].position

        attacking_squares = []
        directions = piece.directions
        original_pos = piece.position
        directions.each do |path|
            pos = original_pos.clone
            moves = []

            if piece.type == 'pawn' && piece.color == 'white'
                attacking_squares = []
                attacking_squares << [original_pos[0]-1, original_pos[1] + 1]
                attacking_squares << [original_pos[0]+1, original_pos[1] + 1]
                break
            elsif piece.type == 'pawn' && piece.color == 'black'
                attacking_squares = []
                attacking_squares << [original_pos[0]-1, original_pos[1] - 1]
                attacking_squares << [original_pos[0]+1, original_pos[1] - 1]
                break
            end

            while pos[0].between?(0,7) && pos[1].between?(0,7)
                pos[0] += path[0]
                pos[1] += path[1]
                moves.append(pos)
                #if the king is in this path, save the path so you can check it later
                #Then look to see if any pieces can move into that path, and that should
                #tell you if there can be any interposition
                

                if pos[0].between?(0,7) && pos[1].between?(0,7)
                    if board.grid[pos[1]][pos[0]] == nil
                        break
                    elsif board.grid[pos[1]][pos[0]].class == Piece
                        attacking_squares << pos.clone
                        break
                    elsif board.grid[pos[1]][pos[0]] == ""
                        attacking_squares << pos.clone
                    end
                else
                    break
                end
                
                if piece.type == 'knight' || piece.type == 'king'
                    break
                end
            end 

         
            if piece.color == 'white' && moves.include?(@black_king_position)
                piece.king_attack_path = moves
            elsif piece.color == 'black' && moves.include?(@white_king_position)
                piece.king_attack_path = moves
            end

            pos = original_pos.clone          
        end
        return attacking_squares
    end

    def move(start, finish)
        @move_complete = false
        piece = board.grid[start[1]][start[0]]
        destination = board.grid[finish[1]][finish[0]].clone
        moves = legal_moves(piece)
        attacking_squares(piece)
        
        if moves.include?(finish)
            piece.position = [finish[0], finish[1]]
            
            board.grid[finish[1]][finish[0]] = piece
            board.grid[start[1]][start[0]] = ""
            if piece.type == 'pawn'
                promotion(piece)
            end
        else
            puts "Please select a valid move"
        end

        check_for_check
        
        if piece.color == 'white' && white_check
            board.grid[finish[1]][finish[0]] = destination
            board.grid[start[1]][start[0]] = piece
            puts "That will put your own king in check, please make a valid move"
            return
        elsif piece.color == 'black' && black_check
            board.grid[finish[1]][finish[0]] = destination
            board.grid[start[1]][start[0]] = piece
            puts "That will put your own king in check, please make a valid move"
            return
        end

        piece.has_moved = true
        @move_complete = true
        if @black_check == true || @white_check == true
            check_for_mate
        end

        print piece.king_attack_path
    end

    def check_for_check
        white_king = board.white_pieces.select {|piece| piece.type == 'king'}
        @white_king_position = white_king[0].position

        black_king = board.black_pieces.select {|piece| piece.type == 'king'}
        @black_king_position = black_king[0].position

        if board.white_pieces.any? { |piece| attacking_squares(piece).include?(black_king_position)}
            @black_check = true
            puts "Black is now in check"
        else
            @black_check = false
        end

        if board.black_pieces.any? { |piece| attacking_squares(piece).include?(white_king_position)}
            @white_check = true
            puts "White is now in check"
        else
            @white_check = false
        end
        
    end

    def check_for_mate
        attacking_wp = board.white_pieces.select{|piece| piece.king_attack_path != []}
        attacking_bp = board.black_pieces.select{|piece| piece.king_attack_path != []}

        freindly_moves = []
        opposition_moves = []
        if @black_check == true
            
            for piece in board.white_pieces
                opposition_moves += attacking_squares(piece)
            end

            for piece in board.black_pieces
                freindly_moves += legal_moves(piece)
            end
            
            if legal_moves(@black_king).any? {|position| opposition_moves.include?(position) == false}
                @black_checkmate = false
            elsif attacking_wp.length == 1
                for move in attacking_wp[0].king_attack_path
                    if freindly_moves.include?(move)
                        @black_checkmate == false
                    end
                end
            else
                @black_checkmate = true
            end

        elsif @white_check == true
            
            for piece in board.black_pieces
                opposition_moves += attacking_squares(piece)
            end

            for piece in board.white_pieces
                freindly_moves += legal_moves(piece)
            end
            
            if legal_moves(@white_king).any? {|position| opposition_moves.include?(position) == false}
                @white_checkmate = false
            elsif attacking_bp.length == 1
                for move in attacking_bp[0].king_attack_path
                    if freindly_moves.include?(move)
                        @white_checkmate == false
                    end
                end
            else
                @white_checkmate = true
            end
        end
    end

    def stalemate_check
        if board.white_pieces.all? {|piece| legal_moves(piece) == []} || board.black_pieces.all? {|piece| legal_moves(piece) == []}
            stalemate = true
        else
            stalemate = false
        end
    end 

    def promotion(pawn)
        if pawn.color == 'white' && pawn.position[1] == 7
            puts "What piece would you like to promote to?"
            selection = gets.chomp.downcase
            case selection.downcase
            when "knight"
                pawn.type = "knight"
                pawn.symbol = "\u265e"
            when "bishop"
                pawn.type = "bishop"
                pawn.symbol = "\u265d"
            when "rook"
                pawn.type = "rook"
                pawn.symbol = "\u265c"
            when "queen"
                pawn.type = "queen"
                pawn.symbol = "\u265b"
            else
                puts "Please select a valid piece to promote to."
                promotion(pawn)
            end
        elsif pawn.color == 'black' && pawn.position[1] == 0
            puts "What piece would you like to promote to?"
            selection = gets.chomp.downcase
            case selection.downcase
            when "knight"
                pawn.type = "knight"
                pawn.symbol = "\u2658"
            when "bishop"
                pawn.type = "bishop"
                pawn.symbol = "\u2657"
            when "rook"
                pawn.type = "rook"
                pawn.symbol = "\u2656"
            when "queen"
                pawn.type = "queen"
                pawn.symbol = "\u2655"
            else
                puts "Please select a valid piece to promote to."
                promotion(pawn)
            end
        else
            return
        end
    end

    def castle
        puts "Which side do you want to castle on?"
        side = gets.chomp.downcase
        if @current_player == 'white'
            if side == 'left'
                if board.grid[0][3] == "" && board.grid[0][2] == "" && board.grid[0][1] == "" && board.grid[0][0].has_moved == false && board.grid[0][4].has_moved == false
                    rook = board.grid[0][0]
                    king = board.grid[0][4]

                    rook.position = [3,0]
                    king.position = [2,0]
            
                    board.grid[0][3] = rook
                    board.grid[0][0] = ""

                    board.grid[0][2] = king
                    board.grid[0][4] = ""
                    return
                end
            elsif side == "right"
                if board.grid[0][5] == "" && board.grid[0][6] == "" && board.grid[0][4].has_moved == false && board.grid[0][7].has_moved == false
                    rook = board.grid[0][7]
                    king = board.grid[0][4]

                    rook.position = [5,0]
                    king.position = [6,0]
            
                    board.grid[0][5] = rook
                    board.grid[0][7] = ""

                    board.grid[0][6] = king
                    board.grid[0][4] = ""
                    return
                end
            end
        elsif @current_player == 'black'
            if side == 'left'
                if board.grid[7][3] == "" && board.grid[7][2] == "" && board.grid[7][1] == "" && board.grid[7][0].has_moved == false && board.grid[7][4].has_moved == false
                    rook = board.grid[7][0]
                    king = board.grid[7][4]

                    rook.position = [3,7]
                    king.position = [2,7]
            
                    board.grid[7][3] = rook
                    board.grid[7][0] = ""

                    board.grid[7][2] = king
                    board.grid[7][4] = ""
                    return
                end
            elsif side == "right"
                if board.grid[7][5] == "" && board.grid[7][6] == "" && board.grid[7][4].has_moved == false && board.grid[7][7].has_moved == false
                    rook = board.grid[7][7]
                    king = board.grid[7][4]

                    rook.position = [5,7]
                    king.position = [6,7]
            
                    board.grid[7][5] = rook
                    board.grid[7][7] = ""

                    board.grid[7][6] = king
                    board.grid[7][4] = ""
                    return
                end
            end
        end
    end

    def play_game
        puts board.to_s
        while @white_checkmate == false && @black_checkmate == false && @stalemate == false
            player_turn
        end
        if @white_checkmate == true
            puts "Black wins!"
        elsif @black_checkmate == true
            puts "White wins!"
        else
            puts "Stalemate, it's a tie!"
        end
    end

end

def start_game
    puts "WELCOME TO CHESS"
    puts "TYPE NEW TO START A NEW GAME, OR LOAD TO LOAD A PREVIOUS GAME"
    option = gets.chomp.downcase
    if option == 'new'
        game = Game.new
        game.play_game
    elsif option == 'load'
        load_game
    else
        puts "Please select a valid option"
        start_game
    end
end

def load_game()
    load_file = File.open("save_file.yaml")
    yaml = load_file.read
    load = YAML::load(yaml)

    load.play_game
end

start_game
