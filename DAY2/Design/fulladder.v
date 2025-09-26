module fulladder(input a,b,cin,output sum,carry);

wire s1,c1,c2;

halfadder submod1(.a(a),
		  .b(b),
		  .sum(s1),
		  .carry(c1));

halfadder submod2(.a(s1),
		  .b(cin),
		  .sum(sum),
		  .carry(c2));
		  
assign carry = c1 | c2 ;

endmodule
