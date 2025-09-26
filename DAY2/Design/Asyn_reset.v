module Asyn_reset(input clk,Asyn_rst,D,output reg Q);

always@(posedge clk,posedge Asyn_rst)begin
	if(Asyn_rst)
		Q <= 1'b0;
	else
		Q <= D;

end

endmodule
