`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////
module tarhi_controller(clk,reset,outp);
   input clk;
   input reset;
   output outp;
   
   wire [31:0] mem_din;
   wire [31:0] mem_dout;
   wire [23:0] mem_addr;
   wire mem_write;
   
   assign outp = 1;
   
   mem mem(
      .clk(clk),
      .mem_write(mem_write),
      .mem_addr(mem_addr),
      .mem_din(mem_dout),
      .mem_dout(mem_din)
   );
   
   tarhi tarhi(
      .clk(clk),
      .reset(reset),
      .mem_addr(mem_addr),
      .mem_write(mem_write),
      .mem_din(mem_din),
      .mem_dout(mem_dout)
   );

endmodule
