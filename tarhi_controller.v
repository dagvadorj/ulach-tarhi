`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////
module tarhi_controller(clk,reset,ledg);
   input clk;
   input reset;
   output [9:0] ledg;
   
   wire mem_enable;
   wire mem_write;
   wire [31:0] mem_din;
   wire [31:0] mem_dout;
   wire [23:0] mem_addr;
   wire [31:0] r0;
   
   assign ledg = r0[9:0];
   
   mem mem(
      .clk(clk),
      .mem_enable(mem_enable),
      .mem_write(mem_write),
      .mem_addr(mem_addr),
      .mem_din(mem_dout),
      .mem_dout(mem_din)
   );
   
   tarhi tarhi(
      .clk(clk),
      .reset(reset),
      .mem_enable(mem_enable),
      .mem_write(mem_write),
      .mem_addr(mem_addr),      
      .mem_din(mem_din),
      .mem_dout(mem_dout),
      .r0(r0)
   );

endmodule
