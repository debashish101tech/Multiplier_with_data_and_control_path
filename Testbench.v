`timescale 1ns / 1ps


module mul_test;
  reg [31:0] data_in;
  reg clk,start;
  wire done;
  wire eqz;
  wire [31:0]y;
  
  mul_datapath DP(y,eqz,LdA,LdB,LdP,clrP,decB,data_in,clk);
  controller CON(LdA,LdB,LdP,clrP,decB,done,clk,eqz,start);
  initial
    begin
      clk=1'b0;
       start=1'b1;
      #240 $finish;
    end
  always #2 clk=~clk;
  initial
    begin
      #8 data_in=8020;
      #4 data_in=9;
    end
  initial
    begin
      $monitor($time,"lda=%d,ldb=%b,ldp=%d,clrp=%d,decb=%d,x=%d,y=%d,z=%d,bout=%d,eqz=%d",DP.LdA,DP.LdB,DP.LdP,DP.clrP,DP.decB,DP.x,DP.y,DP.z,DP.Bout,DP.eqz);
     
    end
endmodule
