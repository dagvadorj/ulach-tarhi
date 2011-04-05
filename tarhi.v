`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
//
//////////////////////////////////////////////////////////////////////////////////
module tarhi(clk, reset, mem_addr, mem_write, mem_din, mem_dout);
   input clk;
   input reset;
   output [23:0] mem_addr;
   input [31:0] mem_din;
   output [31:0] mem_dout;
   output mem_write;   
   
   reg [23:0] mem_addr;
   reg [31:0] mem_dout;
   reg mem_write;
   
   reg [23:0] pc;
   reg [31:0] r0,r1,r2,r3;
   reg [2:0] state;
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
   
   parameter _reset        = 3'b000,
             _fetch        = 3'b001,
             _decode       = 3'b010,
             _exec_read    = 3'b011,
             _exec_write   = 3'b100,
             _exec_jmp     = 3'b101,
             _exec         = 3'b110;
   
   initial begin
      state = _reset;
   end
   
   always @(clk or reset) begin
      if (reset)
         state = _reset;
      else if (clk)
         case(state)
            _reset: begin
               pc = 23'b0;
               state = _fetch;
            end
            _fetch: begin
               instruct = mem_din;
               state = _decode;
               pc = pc + 1;
            end
            _decode:
               case(instruct[31:28])
                  4'b0000: state = _exec_read;
                  4'b0001: state = _exec_write;
                  4'b0010: state = _exec_jmp;
                  4'b0011: state = _exec_jmp;
                  4'b0100: state = _exec_jmp;
                  4'b0101: state = _exec_jmp;
                  4'b0110: state = _exec_jmp;
                  4'b0111: state = _exec_jmp;
                  default: state = _exec;
               endcase
            _exec_read: begin
               case(instruct[27:26])
                  2'b00: r0 = mem_din;
                  2'b01: r1 = mem_din;
                  2'b10: r2 = mem_din;
                  2'b11: r3 = mem_din;
               endcase
               state = _fetch;
            end
            _exec_write: begin
               case(instruct[27:26])
                  2'b00: mem_dout = r0;
                  2'b01: mem_dout = r1;
                  2'b10: mem_dout = r2;
                  2'b11: mem_dout = r3;
               endcase
               state = _fetch;
            end
            _exec_jmp: begin
               pc[23:0] = instruct[23:0];
               state = _fetch;
            end
            _exec: begin
               alu_op = instruct[30:28];
               alu_inp2 = mem_din;
               case(instruct[27:26])
                  2'b00: begin
                     alu_inp1 = r0;                     
                     r0 = alu_outp;
                  end
                  2'b01: begin
                     alu_inp1 = r1;
                     r0 = alu_outp;
                  end
                  2'b10: begin
                     alu_inp1 = r2;
                     r0 = alu_outp;
                  end
                  2'b11: begin
                     alu_inp1 = r3;
                     r0 = alu_outp;
                  end
               endcase
               state = _fetch;
            end
            default:
               state = _fetch;
         endcase
         if (state == _exec_write)
            mem_write = 1'b1;
         else
            mem_write = 1'b0;         
         mem_addr = pc;
   end

endmodule
