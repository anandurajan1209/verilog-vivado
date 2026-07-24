module iterative_comparator_16 (
    input  [15:0] A, B,
    output        AgtB, AeqB, AltB
);
    wire [16:0] gt, lt, eq;

    // Start: cascade inputs at MSB end
    assign gt[16] = 1'b0;
    assign lt[16] = 1'b0;
    assign eq[16] = 1'b1;

    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : iter_cmp
            assign gt[i] = gt[i+1] | (eq[i+1] & A[i] & ~B[i]);
            assign lt[i] = lt[i+1] | (eq[i+1] & ~A[i] & B[i]);
            assign eq[i] = eq[i+1] & ~(A[i] ^ B[i]);
        end
    endgenerate

    assign AgtB = gt[0];
    assign AeqB = eq[0];
    assign AltB = lt[0];
endmodule

