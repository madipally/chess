require_relative '../chess/move_to_target.rb'

describe MoveToTarget do

  before(:each) do
	@object=MoveToTarget.new
  end
  
  context "Knight With Valid Input" do
     it "should move knight to the given target" do
	   piece = 'knight'
	   pos = 'g4'
	   target = 'd8'
	   #opps = ['a2']
	   args = [piece,pos,target] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   res,opponent,moves = validate_steps(@object,steps,args)
       expect(res).to match_array(["h6", "f7"])
	 end
	 
     it "should move knight to the given target and trace the opponent" do
	   piece = 'knight'
	   pos = 'g4'
	   target = 'd8'
	   opps = 'h6'
	   args = [piece,pos,target,opps] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   res,opponent,moves = validate_steps(@object,steps,args)
       expect(res).to match_array(["h6"])
	 end	

     it "should move knight to the given target and should not trace the opponent" do
	   piece = 'knight'
	   pos = 'g4'
	   target = 'd8'
	   opps = 'a2,a3'
	   args = [piece,pos,target,opps] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   res,opponent,moves = validate_steps(@object,steps,args)
       expect(res).to match_array(["h6", "f7"])
	 end	 
   end 
   
  context "Rook With Valid Input" do
     it "should move rook to the given target" do
	   piece = 'rook'
	   pos = 'h8'
	   target = 'h1'
	   args = [piece,pos,target] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   res,opponent,moves = validate_steps(@object,steps,args)
       expect(res).to match_array(["h7", "h6", "h5", "h4", "h3", "h2","h1"])
	 end
	 
     it "should move rook to the given target and trace the opponent" do
	   piece = 'rook'
	   pos = 'h8'
	   target = 'h1'
	   opps = 'h3'
	   args = [piece,pos,target,opps] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   res,opponent,moves = validate_steps(@object,steps,args)
       expect(res).to match_array(["h3"])
	 end	

     it "should move rook to the given target and should not trace the opponent" do
	   piece = 'rook'
	   pos = 'h5'
	   target = 'a1'
	   opps = 'g6,f4'
	   args = [piece,pos,target,opps] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   res,opponent,moves = validate_steps(@object,steps,args)
       expect(res).to match_array(["g5", "f5", "e5", "d5", "c5", "b5","a5","a4","a3","a2","a1"])
	 end	 
   end

  context "Queen With Valid Input" do
     it "should move queen to the given target" do
	   piece = 'queen'
	   pos = 'd1'
	   target = 'h5'
	   args = [piece,pos,target] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   res,opponent,moves = validate_steps(@object,steps,args)
       expect(res).to match_array(["e2", "f3", "g4", "h5"])
	 end
	 
     it "should move queen to the given target and trace the opponent" do
	   piece = 'queen'
	   pos = 'd1'
	   target = 'g8'
	   opps = 'h3,g4'
	   args = [piece,pos,target,opps] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   res,opponent,moves = validate_steps(@object,steps,args)
       expect(res).to match_array(["g4"])
	 end	

     it "should move queen to the given target and should not trace the opponent" do
	   piece = 'queen'
	   pos = 'd1'
	   target = 'g8'
	   opps = 'b6,f4'
	   args = [piece,pos,target,opps] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   res,opponent,moves = validate_steps(@object,steps,args)
       expect(res).to match_array(["e1", "f1", "g1", "g2", "g3", "g4","g5","g6","g7","g8"])
	 end	 
   end    
   
  context "With Invalid Input" do  
     it "should raise runtime error" do
	   piece = 'abc'
	   pos = 'g4'
	   target = 'd8'
	   expect {@object.move_to_target(piece,pos,target,pos)}.to raise_error(RuntimeError)
	 end
	 
     it "should raise runtime error" do
	   piece = 'knight'
	   pos = 'g14'
	   target = 'd8'
	   expect {@object.move_to_target(piece,pos,target,pos)}.to raise_error(RuntimeError)
	 end	

     it "should raise runtime error" do
	   piece = 'queen'
	   pos = 'd1'
	   target = 'g8'
	   opps = 'b16,f4'
	   args = [piece,pos,target,opps] 
	   steps = @object.move_to_target(piece,pos,target,pos)
	   expect {validate_steps(@object,steps,args)}.to raise_error(RuntimeError)
	 end	 
  end	   
end  

