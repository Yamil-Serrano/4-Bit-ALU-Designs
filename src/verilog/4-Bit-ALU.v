module alu_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] OP,
    output reg [3:0] Result,
    output Zero,
    output Carry,
    output Equal
);

wire [3:0] xor_input;
wire [3:0] adder_result;
wire carry_out;
wire [3:0] nand_result;
wire [3:0] xor_result;
wire [3:0] nor_result;

assign nand_result = ~(A & B);      // NAND
assign xor_result  = A ^ B;          // XOR
assign nor_result  = ~(A | B);       // NOR

// --- Adder/Subtractor Logic ---
assign xor_input = B ^ {4{OP[2]}}; // Represents the xor of every full adder that takes B and Opcode[2].
assign {carry_out, adder_result} = A + xor_input + OP[2]; // Represents the sum of A and B, where B is 
                                                          // XORed with Opcode[2] to determine if it's 
                                                          // an addition or subtraction. The carry_out 
                                                          // is the carry from the most significant bit.

// --- Multiplexer for Result ---
always @(*) begin
    case (OP[1:0])
        2'b00: begin
            if (OP[2] == 0)
                Result = adder_result;    // SUM
            else
                Result = adder_result;    // SUB
        end
        
        2'b01: Result = nand_result;     // NAND
        2'b10: Result = xor_result;      // XOR
        2'b11: Result = nor_result;      // NOR
    endcase
end

// --- Flags ---
assign Zero  = (Result == 4'b0);
assign Carry = carry_out;
assign Equal = (A == B);

endmodule