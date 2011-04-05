`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////
module mem(clk, mem_write, mem_addr, mem_din, mem_dout);
   input clk;
   input mem_write;
   input [23:0] mem_addr;
   input [31:0] mem_din;
   output [31:0] mem_dout;
   
   reg [31:0] content [2**5-1:0];
   reg [31:0] mem_dout;
   
   initial
      $readmemb("ram.dat", content, 0, 2**5-1);
   
   always @(negedge clk) begin
      if (mem_write)
         content[mem_addr] = mem_din;
      mem_dout = content[mem_addr];
   end
   
endmodule
