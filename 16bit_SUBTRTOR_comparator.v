module subtractor_comparator_16 (
    input  [15:0] A, B,
    output        AgtB, AeqB, AltB
);
    wire [16:0] diff;
    assign diff = {1'b0, A} - {1'b0, B};

    // diff[16] = borrow = 1 when A < B (unsigned)
    assign AltB = diff[16];
    assign AeqB = (diff[15:0] == 16'b0);
    assign AgtB = ~diff[16] & ~AeqB;
endmodule
