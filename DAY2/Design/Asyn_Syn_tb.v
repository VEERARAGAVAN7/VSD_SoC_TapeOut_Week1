module Asyn_Syn_tb();
reg clk = 0,Syn_rst,D = 0;
wire Q;

always #10 clk = ~ clk;
always #70 D = ~ D;

//Asyn_reset dut1(.clk(clk),
//		.Asyn_rst(Asyn_rst),
//		.D(D), 
//		.Q(Q));

Syn_reset Syn_reset(.clk(clk),
		    .Syn_rst(Syn_rst),
		    .D(D), 
		    .Q(Q));
		      
initial begin
	
#100 Syn_rst = 1'b1;
#100 Syn_rst = 1'b0;
#200 Syn_rst = 1'b1;
#200 Syn_rst = 1'b0;
#100 $finish;

end

initial begin
$dumpfile("Asyn_rst.vcd");
$dumpvars(0);
end

endmodule
