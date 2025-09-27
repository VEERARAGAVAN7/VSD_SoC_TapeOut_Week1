module opt_check2 (input a , input b , output y);
	assign y = a?1:b; // optimized to OR gate with input a,b(which is done by consenus theorem
endmodule

