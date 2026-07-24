module tree_comparator_16 (
    input  [15:0] A, B,
    output        AgtB, AeqB, AltB
);
    wire [15:0] xnor_bits;
    assign xnor_bits = ~(A ^ B);    // 1 where bits are equal

    // Level-1 AND pairs  (8 outputs)
    wire [7:0] l1;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : tree_l1
            assign l1[i] = xnor_bits[2*i] & xnor_bits[2*i+1];
        end
    endgenerate

    // Level-2 AND pairs  (4 outputs)
    wire [3:0] l2;
    generate
        for (i = 0; i < 4; i = i + 1) begin : tree_l2
            assign l2[i] = l1[2*i] & l1[2*i+1];
        end
    endgenerate

    // Level-3 AND pairs  (2 outputs)
    wire [1:0] l3;
    assign l3[0] = l2[0] & l2[1];
    assign l3[1] = l2[2] & l2[3];

    // Level-4: final equality
    assign AeqB = l3[0] & l3[1];

    // Magnitude: MSB-first priority encoder on differing bits
    // (scan from bit 15 downward for first difference)
    wire [15:0] diff_mask;
    assign diff_mask = A ^ B;

    // Find highest set bit in diff_mask; compare that bit
    wire [4:0] hi;    // index of highest differing bit
    assign hi = diff_mask[15] ? 5'd15 :
                diff_mask[14] ? 5'd14 :
                diff_mask[13] ? 5'd13 :
                diff_mask[12] ? 5'd12 :
                diff_mask[11] ? 5'd11 :
                diff_mask[10] ? 5'd10 :
                diff_mask[9]  ? 5'd9  :
                diff_mask[8]  ? 5'd8  :
                diff_mask[7]  ? 5'd7  :
                diff_mask[6]  ? 5'd6  :
                diff_mask[5]  ? 5'd5  :
                diff_mask[4]  ? 5'd4  :
                diff_mask[3]  ? 5'd3  :
                diff_mask[2]  ? 5'd2  :
                diff_mask[1]  ? 5'd1  : 5'd0;

    assign AgtB = ~AeqB & A[hi];
    assign AltB = ~AeqB & B[hi];
endmodule
