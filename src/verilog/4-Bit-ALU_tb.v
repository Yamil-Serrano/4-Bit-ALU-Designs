`timescale 1ns/1ps

module test;

    // DUT Signals
    reg  [3:0] A, B;
    reg  [2:0] OP;
    wire [3:0] Result;
    wire       Zero, Carry, Equal;

    alu_4bit uut (.A(A), .B(B), .OP(OP),.Result(Result),.Zero(Zero), .Carry(Carry), .Equal(Equal));

    // Per-opcode hit counters (0..7)
    integer hits   [0:7];
    integer op_idx;

    // Flag counters
    integer eq_hits, zr_hits, zr_total;
    integer eq_pct_int, eq_pct_frac;
    integer zr_pct_int, zr_pct_frac;

    // Aux
    integer i, j, op;
    reg [3:0] expected_result;
    reg [4:0] expected_full;

    // Expected result function
    function [3:0] expected;
        input [2:0] opcode;
        input [3:0] a, b;
        reg [4:0] tmp;
        begin
            case (opcode)
                3'b000:          begin tmp = a + b;      expected = tmp[3:0]; end // ADD
                3'b100:          begin tmp = a - b;      expected = tmp[3:0]; end // SUB
                3'b001, 3'b101:  expected = ~(a & b);                            // NAND
                3'b010, 3'b110:  expected =   a ^ b;                             // XOR
                3'b011, 3'b111:  expected = ~(a | b);                            // NOR
                default:         expected = 4'bx;
            endcase
        end
    endfunction

    // Opcode name helper
    task print_op_name;
        input [2:0] opcode;
        begin
            case (opcode)
                3'b000: $write("ADD ");
                3'b100: $write("SUB ");
                3'b001: $write("NAND");
                3'b101: $write("NAND");
                3'b010: $write("XOR ");
                3'b110: $write("XOR ");
                3'b011: $write("NOR ");
                3'b111: $write("NOR ");
            endcase
        end
    endtask

    // Integer percentage helpers (avoids %f)
    function integer pct_int;   // whole part
        input integer h, t;
        begin pct_int  = (h * 100) / t; end
    endfunction

    function integer pct_frac;  // one decimal digit
        input integer h, t;
        begin pct_frac = ((h * 1000) / t) % 10; end
    endfunction

    // MAIN
    initial begin

        // (256 combinations) Per-opcode test 
        for (op = 0; op < 8; op = op + 1) begin
            hits[op] = 0;
            OP = op;
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    A = i; B = j;
                    #10;
                    if (Result === expected(OP, A, B))
                        hits[op] = hits[op] + 1;
                end
            end
        end

        //  Equal flag test 
        eq_hits = 0;
        OP = 3'b000;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                A = i; B = j;
                #10;
                if (Equal === (A == B))
                    eq_hits = eq_hits + 1;
            end
        end

        //  Zero flag test (all opcodes) 
        zr_hits = 0; zr_total = 0;
        for (op = 0; op < 8; op = op + 1) begin
            OP = op;
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    A = i; B = j;
                    #10;
                    if (Zero === (expected(OP, A, B) == 4'b0))
                        zr_hits = zr_hits + 1;
                    zr_total = zr_total + 1;
                end
            end
        end

        // REPORT
        $display("");
        $display("-------------------------------------------------------------");
        $display("                    ALU OPCODE MAP");
        $display("-------------------------------------------------------------");
        $display("  Op  |  Bits  |  Func  |  Hits");
        $display("------------------------------------------------------------");

        for (op = 0; op < 8; op = op + 1) begin
            $write("  %0d    |  %b  |  ", op, op[2:0]);
            print_op_name(op);
            $write("  |  %0d/256 (%0d.%0d%%)",
                hits[op],
                pct_int(hits[op], 256),
                pct_frac(hits[op], 256));
            if (hits[op] == 256) $write("  [PASS]");
            else                  $write("  [WARN]");
            $display("");
        end

        $display("------------------------------------------------------------");

        //  PASS list 
        $display("");
        $display("  [PASS] 100%% match:");
        for (op = 0; op < 8; op = op + 1) begin
            if (hits[op] == 256) begin
                $write("    Opcode %0d -> ", op);
                print_op_name(op);
                $display("");
            end
        end

        //  WARNING list 
        $display("");
        $display("  [WARN] Partial match:");
        begin : warn_block
            integer any_warn;
            any_warn = 0;
            for (op = 0; op < 8; op = op + 1) begin
                if (hits[op] < 256 && hits[op] > 0) begin
                    any_warn = 1;
                    $write("    Opcode %0d -> ", op);
                    print_op_name(op);
                    $display(" (%0d.%0d%%)",
                        pct_int(hits[op], 256),
                        pct_frac(hits[op], 256));
                end
            end
            if (any_warn == 0)
                $display("    None");
        end

        //  FAIL list 
        $display("");
        $display("  [FAIL] 0%% match:");
        begin : fail_block
            integer any_fail;
            any_fail = 0;
            for (op = 0; op < 8; op = op + 1) begin
                if (hits[op] == 0) begin
                    any_fail = 1;
                    $write("    Opcode %0d -> ", op);
                    print_op_name(op);
                    $display("");
                end
            end
            if (any_fail == 0)
                $display("    None");
        end

        //  Flag results 
        $display("");
        $display("-------------------------------------------------------------");
        $display("                       FLAG TESTS");
        $display("-------------------------------------------------------------");
        $display("  Flag  |  Description                 |  Result");
        $display("------------------------------------------------------------");
        $display("  EQ    |  Nibble A equal to Nibble B  |  %0d/256 (%0d.%0d%%)",
            eq_hits,
            pct_int(eq_hits, 256),
            pct_frac(eq_hits, 256));
        $display("  ZR    |  When ALU Result = 0000      |  %0d/%0d (%0d.%0d%%)",
            zr_hits, zr_total,
            pct_int(zr_hits, zr_total),
            pct_frac(zr_hits, zr_total));
        $display("------------------------------------------------------------");
        $display("                    ALU TEST COMPLETE");
        $display("-------------------------------------------------------------");

        $finish;
    end

endmodule