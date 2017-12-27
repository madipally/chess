class Chess

  PIECES = ['knight','rook','queen']
  COLS = ['a','b','c','d','e','f','g','h']
  ROWS = [1,2,3,4,5,6,7,8]
  KNIGHT_MOVES_ARR = [[-1,-2],[1,-2],[-2,-1],[2,-1],[-1,2],[1,2],[-2,1],[2,1]]
  QUEEN_MOVES_ARR = [[1,1],[-1,-1],[1,-1],[-1,1],[0,1],[0,-1],[1,0],[-1,0]]
  ROOK_MOVES_ARR = [[0,1],[0,-1],[1,0],[-1,0]]
  
  def move_col(pos,count)
   col = (pos.ord + count).chr
   return col if validate_pos?(1,col)
  end  
  
  def validate_pos?(row,col)
    res = ROWS.include?(row) ? row : false
    return res if res == false
    res =COLS.include?(col) ? col : false
    return res if res == false
    
    return true
  end
  
  def validate_piece(piece)
    PIECES.include?(piece.downcase) ? true : false
  end
  
end
