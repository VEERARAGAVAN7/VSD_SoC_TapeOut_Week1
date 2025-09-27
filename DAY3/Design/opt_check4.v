module opt_check4 (input a , input b , input c , output y);
 assign y = a?(b?(a & c ):c):(!c);//optimized to a xnot c 
 endmodule
