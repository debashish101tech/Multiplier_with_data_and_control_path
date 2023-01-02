`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIITA
// Engineer: Debashish
// 
// Create Date: 08.10.2022 14:05:27
// Design Name: 
// Module Name: mul_datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mul_datapath(y,eqz,LdA,LdB,LdP,clrP,decB,data_in,clk);
  input LdA,LdB,LdP,clrP,decB,clk;
  input [31:0] data_in;
  output eqz;
  output [31:0]y;
  wire [31:0]x,z,Bout;
  PIPO1 A(x,data_in,LdA,clk);
  PIPO2 P(y,z,LdP,clrP,clk);
  CNTR B(Bout,data_in,LdB,decB,clk);
  ADD AD(z,x,y);
  EQZ COMP(eqz,Bout);
endmodule

module PIPO1(dout,din,ld,clk);
  input [31:0] din;
  input ld,clk;
  output reg[31:0]dout;
  always@(posedge clk)
    if(ld) dout=din;
endmodule

module ADD(out,in1,in2);
  input [31:0] in1,in2;
  output [31:0] out;
  assign out=in1+in2;
endmodule

module PIPO2(dout,din,ld,clr,clk);
  input [31:0]din;
  input ld,clr,clk;
  output reg[31:0] dout;
  always @(posedge clk)
    if (clr) dout<=16'b0;
  else if(ld) dout<=din;
endmodule

module EQZ(eqz,data);
  input [31:0] data;
  output eqz;
  assign eqz=(data==0);
endmodule

module CNTR(dout,din,ld,dec,clk);
  input [31:0]din;
  input ld,dec,clk;
  output reg [31:0] dout;
  always @(posedge clk)
  begin
    if(ld) dout<=din;
    else if (dec) 
        dout<=dout-1;
    end
  
endmodule

module controller(LdA,LdB,LdP,clrP,decB,done,clk,eqz,start);
  input clk,eqz,start;
  output reg LdA,LdB,LdP,clrP,decB,done;
  reg [2:0]state;
  parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011,S4=3'b100;
  always @(posedge clk)
    begin
      case(state)
        S0:if(start) state<=S1;
        S1:state<=S2;
        S2: state<=S3;
        S3: #1 if(eqz) state<=S4;
        S4:state<=S4;
        default: state<=S0;
      endcase
    end
  always @(state)
    begin
      case(state)
        S0:begin  LdA=0;LdB=0;LdP=0;clrP=1;decB=0;end
        S1:begin  LdA=1;clrP=0;end
        S2:begin  LdA=0;LdB=1;end
        S3:begin  LdB=0;LdP=1;clrP=0;decB=1;end
        S4:begin  done=1;LdB=0;LdP=0;decB=0;end
        default: begin LdA=0;LdB=0;LdP=0;clrP=0;decB=0;end
      endcase
    end
endmodule
