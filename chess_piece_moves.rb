  
require 'benchmark'
require_relative 'chess'

class ChessPieceMoves < Chess
  
  def initialize
    @moves =[]
  end
  
  def piece_move(piece,pos)
     puts "erer"
	 puts pos
     col = pos[0].downcase
     row = pos[1..pos.length].to_i
     
     raise "Invalid piece #{piece}" if validate_piece(piece) == false
     raise "Invalid row #{row} at #{pos}" if validate_pos?(row,'a') == false
     raise "Invalid column #{col} at #{pos}" if validate_pos?(1,col) == false
     
     case piece
       when 'knight'
         step_arr = KNIGHT_MOVES_ARR
       when 'queen'
         step_arr = QUEEN_MOVES_ARR
       when 'rook'
         step_arr = ROOK_MOVES_ARR         
     end
         step_arr.each do |elem|
          @moves = move_forward(piece,row,col,elem,count=0)
         end 
     return @moves
  end
  
    
  def move_forward(piece,row,col,elem,count)
     row_to_move = row + (elem[0])
     col_to_move = move_col(col,elem[1])
     if validate_pos?(row_to_move,'a')
       if col_to_move
         return @moves<<"#{col_to_move}#{row_to_move}" if piece == 'knight'
         move_forward(piece,row_to_move,col_to_move,elem,count+=1)
       else
        @moves<<"#{col}#{row}" if count!=0
        return @moves
       end
     else
      @moves<<"#{col}#{row}"  if count!=0
      return @moves
    end    
  end
end



time = Benchmark.measure do
  piece = ARGV[0].downcase
  move = ARGV[1]

  print steps=ChessPieceMoves.new.piece_move(piece,move)
end

puts time





  