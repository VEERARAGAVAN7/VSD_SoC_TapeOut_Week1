module opt_check (input a , input b , output y);
	assign y = a?b:0; //optimized to And gate with a,b input
endmodule


