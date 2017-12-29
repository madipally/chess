require 'benchmark'
require_relative 'chess'

class MoveToTarget < Chess

  
  def initialize
    @moves =[]
    @knight_steps=[]
    @all_moves=[]
  end
  
  def move_to_target(piece,pos,target,original_pos)
  
     	 
	 raise "Invalid piece #{piece}" if validate_piece(piece) == false
	 validate_move(pos)
	 validate_move(target)
	 
	 @moves << pos
     @moves,stop = move_piece(piece,pos,target)

     @all_moves << @moves
     if piece !='knight'
       return @moves if stop == 1
       @moves =[]<< "#{target[0].downcase}#{pos[1].to_i}"
       @moves << "#{target[0].downcase}#{target[1].to_i}" 
       @num_steps = @moves.count
       moving_steps = trace_opponent(pos,target)
       return moving_steps
     else
       return @knight_steps if @moves.include?(target)
       nearest_moves = @moves.dup
       nearest_rows = get_nearest_row(pos,target,nearest_moves)
       nearest_col = get_nearest_col(nearest_rows,target,pos)
       if ((@knight_steps.count >= 0) && (!@knight_steps.include?(nearest_col)))
         @knight_steps << nearest_col 
         @moves = []
         move_to_target(piece,nearest_col,target,original_pos)
       else
         @all_moves.each do |moves|
           @knight_steps << moves[0]
           nearest_moves = moves - @knight_steps
           next if nearest_moves.empty?
           #@knight_steps = []
           nearest_rows = get_nearest_row(original_pos,target,nearest_moves)
           nearest_col = get_nearest_col(nearest_rows,target,pos)
           @knight_steps << nearest_col
           @moves = []
           move_to_target(piece,nearest_col,target,original_pos)
           return @knight_steps if @moves.include?(target)
         end
      end
     end
  end
  
  def get_nearest_row(pos,target,nearest_moves)
    target_row = target[1].to_i
    pos_row = pos[1].to_i
    pos_col = pos[0]
    
    nearest_moves.delete_if {|elem| elem[1].to_i == target_row }
    nearest_moves.sort_by! {|move| move[/\d+/].to_i}
    
    if target_row < pos_row
      nearest_row = nearest_moves[0]
    else
      nearest_row = nearest_moves[nearest_moves.length-1]
    end
    nearest_moves.delete_if {|elem| elem[1] != nearest_row[1] }
    return nearest_moves.sort!
  end
  
  def get_nearest_col(nearest_rows,target,pos)
    pos_row = pos[1].to_i
    pos_col = pos[0]
    target_row = target[1].to_i
    target_col = target[0]
    
    #nearest_rows.delete_if {|elem| elem[0] == target_col }
    
    if target_col > pos_col
      nearest_col = nearest_rows[nearest_rows.length-1]
    else
      nearest_col = nearest_rows[0]
    end
  end
  
  def trace_opponent(pos,target)
    pos_row = pos[1]
    pos_col = pos[0]
    
    initial_target = @moves[0]
    initial_target_row = initial_target[1]
    initial_target_col = initial_target[0]
    
    target_row = target[1]
    target_col = target[0]
    
    pos_col > initial_target_col ? count = -1 : count = 1
    moving_steps = []
    steps = []

    loop do
      break if pos_col == initial_target_col
      pos_col = move_col(pos_col,count)
      moving_steps << "#{pos_col}#{pos_row}"
    end
    

    if initial_target_row > target_row 
      req_range = (target_row..initial_target_row).to_a
      req_reverse = true
    else
       req_range = (initial_target_row..target_row).to_a
       req_reverse = false
    end  
    
    for move in req_range
     steps << "#{initial_target_col}#{move}"
    end
    
    steps.reverse! if req_reverse
    
    moving_steps << steps
 
    return moving_steps.flatten!.uniq!
  end  
  
  def move_piece(piece,pos,target)

     col = pos[0].downcase
     row = pos[1].to_i

     case piece
       when 'knight'
         step_arr = KNIGHT_MOVES_ARR
       when 'queen'
         step_arr = QUEEN_MOVES_ARR
       when 'rook'
         step_arr = ROOK_MOVES_ARR         
     end 
     step_arr.each do |elem|
      @moves=[] if piece != 'knight'
      @moves,stop = move_forward(piece,row,col,elem,count=0,target)
        return @moves,stop if stop == 1
     end 
    return @moves,stop=0
  end
  
  def move_forward(piece,row,col,elem,count,target)
     row_to_move = row + (elem[0])
     col_to_move = move_col(col,elem[1])
	 if validate_pos?(row_to_move,'a')
       if col_to_move
		   	@moves << "#{col_to_move}#{row_to_move}" 
	        if target == "#{col_to_move}#{row_to_move}" &&  piece != 'knight'
	          return @moves,stop=1
	        end
         return @moves,stop=0 if piece == 'knight'
         move_forward(piece,row_to_move,col_to_move,elem,count+=1,target)
       else
        @moves<<"#{col}#{row}" if count!=0
        return @moves,stop=0
       end
     else
      @moves<<"#{col}#{row}"  if count!=0
      return @moves,stop=0
    end    
  end
end

def validate_steps(obj,steps,args)

     piece = args[0].downcase
	 pos = args[1]
	 target = args[2]
	 
	 steps.reverse!
	 moves = []

	 steps.each do |step|
	   if step == pos
		 break
	   else
		 moves << step
	   end
	 end
	 moves.reverse!
	 
	 if !args[3].nil?
		 opponent_piecs_pos = args[3].split(',')
		 
		 opponent_piecs_pos.each do |pos|
		   obj.validate_move(pos)
		 end
		 
		 opp_array = opponent_piecs_pos.inject([]) do |opp_array,elem|
		  opp_array << elem if moves.include?(elem)
		  opp_array
		 end
		 
		 opp_array.sort!
		 if opp_array.size > 0
			return opp_array,opponent = true,moves
		 else
			return moves,opponent = false,nil
		 end		
	 else
	    return moves,opponent = false,nil
	end 
end

if __FILE__ == $0
  if !ARGV.empty?
	 piece = ARGV[0].downcase
	 pos = ARGV[1]
	 target = ARGV[2]
	 
	 raise "Invalid input" if piece.nil? || pos.nil? || target.nil?
	 
	 obj = MoveToTarget.new
	
	 steps = obj.move_to_target(piece,pos,target,pos)
	 result,opponent,moves = validate_steps(obj,steps,ARGV)

	 if opponent
	   puts  "Captured the opponent at #{result[0]} while moving the #{piece} from #{pos} to #{target} in #{moves}  "
	 else
	   puts "moved the #{piece} in #{result.size} steps from #{pos}  to #{target} in #{result} steps "	
	 end
  else
	puts "Please provide input" 		
  end
end	





  