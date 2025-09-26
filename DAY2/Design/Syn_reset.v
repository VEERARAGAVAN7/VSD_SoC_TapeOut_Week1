module Syn_reset(input clk,Syn_rst,D,output reg Q);

always@(posedge clk)begin
	if(Syn_rst)
		Q <= 1'b0;
	else
		Q <= D;
end

endmodule
