module mux(input I0,I1,Sel,output Out);

assign Out = Sel ? I1 : I0;

endmodule
