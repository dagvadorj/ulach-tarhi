`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////
module alu(op,inp1,inp2,outp);
   input [2:0] op;
   input [31:0] inp1;
   input [31:0] inp2;
   output [31:0] outp;
   
   reg [31:0] outp;
   
   always @(op or inp1 or inp2) begin
      case (op)
         3'b000: outp = inp1 + inp2;
         3'b001: outp = inp1 << inp2;
         3'b010: outp = inp1 >> inp2;
         3'b011: outp = inp1 & inp2;
         3'b100: outp = inp1 | inp2;
         3'b101: outp = inp1 ^ inp2;
         3'b110: outp = ~inp1;
         3'b111: outp = 1;
      endcase
   end

endmodule
