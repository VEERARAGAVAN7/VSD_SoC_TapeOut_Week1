module Asyn_reset(input clk,Asyn_set,D,output reg Q);

always@(posedge clk,posedge Asyn_set)begin
	if(Asyn_set)
		Q <= 1'b1;
	else
		Q <= D;

end

endmodule
