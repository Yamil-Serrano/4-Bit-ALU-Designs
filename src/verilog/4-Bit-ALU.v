module top (
    output wire Zero,

    input wire OP_code0,
    input wire OP_code1,

    input wire bit3A,
    input wire bit2A,
    input wire bit1A,
    input wire bit0A,

    input wire bit3B,
    input wire bit2B,
    input wire bit1B,
    input wire bit0B,

    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3
);

wire bit0_xor;
wire bit1_xor;
wire bit2_xor;
wire bit3_xor;

assign bit0_xor = bit0B ^ OP_code1;
assign bit1_xor = bit1B ^ OP_code1;
assign bit2_xor = bit2B ^ OP_code1;
assign bit3_xor = bit3B ^ OP_code1;

wire adder_bit0; 
wire adder_bit1;
wire adder_bit2;
wire adder_bit3;

wire carry_out0;
wire carry_out1;
wire carry_out2;
wire carry_out3;

// 4-Bit full adder
assign adder_bit0  = bit0A ^ bit0_xor ^ OP_code1;
assign carry_out0  = (bit0A & bit0_xor) | (OP_code1 & (bit0A ^ bit0_xor));
assign adder_bit1  = bit1A ^ bit1_xor ^ carry_out0;
assign carry_out1  = (bit1A & bit1_xor) | (carry_out0 & (bit1A ^ bit1_xor));
assign adder_bit2  = bit2A ^ bit2_xor ^ carry_out1;
assign carry_out2  = (bit2A & bit2_xor) | (carry_out1 & (bit2A ^ bit2_xor));
assign adder_bit3  = bit3A ^ bit3_xor ^ carry_out2;
assign carry_out3  = (bit3A & bit3_xor) | (carry_out2 & (bit3A ^ bit3_xor));

// Mux Nand and Adder
assign output0 = ((~(bit0A & bit0B) & ~(OP_code0) & 1) | (adder_bit0 & OP_code0 & 1));
assign output1 = ((~(bit1A & bit1B) & ~(OP_code0) & 1) | (adder_bit1 & OP_code0 & 1));
assign output2 = ((~(bit2A & bit2B) & ~(OP_code0) & 1) | (adder_bit2 & OP_code0 & 1));
assign output3 = ((~(bit3A & bit3B) & ~(OP_code0) & 1) | (adder_bit3 & OP_code0 & 1));

// Output
assign led0 = output0;
assign led1 = output1;
assign led2 = output2;
assign led3 = output3;

// Zero flag
assign Zero = ~(output0 | output1 | output2 | output3);

endmodule