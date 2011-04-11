`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////
module tarhi(clk, reset, mem_enable, mem_write, mem_addr, mem_din, mem_dout, r0);
   input clk;
   input reset;
   input [31:0] mem_din;
   
   output mem_enable;
   output mem_write;
   output [23:0] mem_addr;
   output [31:0] mem_dout;
   output [31:0] r0;
   
   reg mem_enable;
   reg mem_write;
   reg [23:0] mem_addr;
   reg [31:0] mem_dout;
   
   reg [23:0] pc;
   reg [31:0] r0;
   reg [31:0] r1,r2,r3;
   reg [2:0] state;
   reg [1:0] exec_state;
   reg [31:0] instruct;
   
   reg [2:0] alu_op;
   reg [31:0] alu_inp1;
   reg [31:0] alu_inp2;
   wire [31:0] alu_outp;
   
   alu alu(
      .op(alu_op),
      .inp1(alu_inp1),
      .inp2(alu_inp2),
      .outp(alu_outp)
   );
   
   parameter _reset   = 3'b000,
             _fetch0  = 3'b001,
             _fetch1  = 3'b010,
             _decode  = 3'b011,
             _exec    = 3'b100;
   parameter _read    = 2'b00,
             _write   = 2'b01,
             _jmp     = 2'b10,
             _alu     = 2'b11;
   
   initial begin
      state <= _reset;
   end
   
   always @(clk or reset) begin
      if (reset) state <= _reset;
      else if (clk)
         case(state)
            _reset: begin
               pc <= 23'b0;
               state <= _fetch0;
            end
            _fetch0: begin // fetch
               mem_addr <= pc;
               state <= _fetch1;
            end
            _fetch1: begin // 
               instruct <= mem_din;
               pc <= pc + 1;
               state <= _decode;               
            end
            _decode: begin // decode
               state <= _exec;
               case(instruct[31:30])
                  2'b00: begin
                     mem_addr <= instruct[23:0];
                     exec_state <= _read;
                  end
                  2'b01: begin
                     mem_addr <= instruct[23:0];
                     exec_state <= _write;
                  end
                  2'b10: exec_state <= _jmp;
                  2'b11: exec_state <= _alu;
               endcase
            end
            _exec: begin
               case(exec_state)
                  _read: begin // read from memory
                     case(instruct[29:28])
                        2'b00: r0 <= mem_din;
                        2'b01: r1 <= mem_din;
                        2'b10: r2 <= mem_din;
                        2'b11: r3 <= mem_din;
                     endcase
                  end
                  _write: begin // write to memory
                     case(instruct[29:28])
                        2'b00: mem_dout <= r0;
                        2'b01: mem_dout <= r1;
                        2'b10: mem_dout <= r2;
                        2'b11: mem_dout <= r3;
                     endcase
                  end
                  _jmp: begin // jump to memory
                     pc <= instruct[23:0];
                  end
                  _alu: begin // arithmetic-logic unit
                     alu_op <= instruct[29:27];
                     case(instruct[26:25])
                        2'b00: alu_inp1 <= r0;
                        2'b01: alu_inp1 <= r1;
                        2'b10: alu_inp1 <= r2;
                        2'b11: alu_inp1 <= r3;
                     endcase
                     case(instruct[24:23])
                        2'b00: alu_inp2 <= r0;
                        2'b01: alu_inp2 <= r1;
                        2'b10: alu_inp2 <= r2;
                        2'b11: alu_inp2 <= r3;
                     endcase
                     case(instruct[22:21])
                        2'b00: r0 <= alu_outp;
                        2'b01: r1 <= alu_outp;
                        2'b10: r2 <= alu_outp;
                        2'b11: r3 <= alu_outp;
                     endcase
                  end
               endcase
               state <= _fetch0;
            end
            default: state <= _fetch0;
         endcase
         if (state == _fetch0 || exec_state == _read || exec_state == _write)
            mem_enable <= 1'b1;
         else mem_enable <= 1'b0;
         if (exec_state == _write) mem_write <= 1'b1;
         else mem_write <= 1'b0;
   end

endmodule
