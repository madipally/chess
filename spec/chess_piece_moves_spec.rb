require_relative '../chess/chess_piece_moves'

describe ChessPieceMoves do

  before(:each) do
	@object=ChessPieceMoves.new
  end
  
  context "With Valid Input" do
     it "should move knight to the required positions" do
	   piece = 'knight'
	   move = 'b1'
	   moves = @object.piece_move(piece,move)
       expect(moves).to match_array(['a3','c3','d2'])
	 end
	 
	 it "should move rook to the required positions" do
	    piece = "rook"
		move = "d4"
		moves = @object.piece_move(piece,move)
		expect(moves).to match_array(["h4", "a4", "d8", "d1"])
	 end
	 
	 it "should move queen to the required positions" do
	    piece = "queen"
		move = "d1"
	    moves = @object.piece_move(piece,move)
		expect(moves).to match_array(["h5", "a4", "h1", "a1", "d8"])
	 end	 
  end
  
  context "With Invalid Input" do  
     it "should raise runtime error" do
		 piece = "abc"
		 move = "b1"
		 expect {@object.piece_move(piece,move)}.to raise_error(RuntimeError)
	 end
	 
     it "should raise runtime error" do
		 piece = "rook"
		 move = "b10"
		 expect {@object.piece_move(piece,move)}.to raise_error(RuntimeError)
	 end	 
  end	
  
end  

