module magnitude_comparator_4bit (
    input  [3:0] A, B,
    input        IAGTB, IAEQB, IALTB,  // cascade inputs
    output       OAGTB, OAEQB, OALTB   // cascade outputs
);
    wire [3:0] eq_bit;
    assign eq_bit = ~(A ^ B);           // per-bit equality flags

    wire all_eq = eq_bit[3] & eq_bit[2] & eq_bit[1] & eq_bit[0];

    // Priority: MSB first
    wire gt_local = (A[3] & ~B[3]) |
                    (eq_bit[3] & A[2] & ~B[2]) |
                    (eq_bit[3] & eq_bit[2] & A[1] & ~B[1]) |
                    (eq_bit[3] & eq_bit[2] & eq_bit[1] & A[0] & ~B[0]);

    wire lt_local = (~A[3] & B[3]) |
                    (eq_bit[3] & ~A[2] & B[2]) |
                    (eq_bit[3] & eq_bit[2] & ~A[1] & B[1]) |
                    (eq_bit[3] & eq_bit[2] & eq_bit[1] & ~A[0] & B[0]);

    assign OAGTB = gt_local | (all_eq & IAGTB);
    assign OALTB = lt_local | (all_eq & IALTB);
    assign OAEQB = all_eq   & IAEQB;
endmodule

module magnitude_comparator_16 (
    input  [15:0] A, B,
    output        AgtB, AeqB, AltB
);
    wire gt01, eq01, lt01;
    wire gt02, eq02, lt02;
    wire gt03, eq03, lt03;

    // Block 0: bits [3:0], cascade inputs set for equality
    magnitude_comparator_4bit blk0 (
        .A(A[3:0]),   .B(B[3:0]),
        .IAGTB(1'b0), .IAEQB(1'b1), .IALTB(1'b0),
        .OAGTB(gt01), .OAEQB(eq01), .OALTB(lt01)
    );

    // Block 1: bits [7:4]
    magnitude_comparator_4bit blk1 (
        .A(A[7:4]),   .B(B[7:4]),
        .IAGTB(gt01), .IAEQB(eq01), .IALTB(lt01),
        .OAGTB(gt02), .OAEQB(eq02), .OALTB(lt02)
    );

    // Block 2: bits [11:8]
    magnitude_comparator_4bit blk2 (
        .A(A[11:8]),  .B(B[11:8]),
        .IAGTB(gt02), .IAEQB(eq02), .IALTB(lt02),
        .OAGTB(gt03), .OAEQB(eq03), .OALTB(lt03)
    );

    // Block 3: bits [15:12] — final output
    magnitude_comparator_4bit blk3 (
        .A(A[15:12]), .B(B[15:12]),
        .IAGTB(gt03), .IAEQB(eq03), .IALTB(lt03),
        .OAGTB(AgtB), .OAEQB(AeqB), .OALTB(AltB)
    );
endmodule
