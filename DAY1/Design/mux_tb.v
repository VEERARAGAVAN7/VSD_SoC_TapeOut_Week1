module mux_tb();

reg I0=0,I1=1,Sel=0;
wire Out;

mux dut (.I0(I0),
	 .I1(I1),
	 .Sel(Sel),
	 .Out(Out));

always #50 Sel = ~Sel;

initial begin
#100 I0 = 1; 
     I1 = 0;
#300 $finish;

end

initial begin
$dumpfile("mux.vcd");
$dumpvars(0);
end

endmodule
