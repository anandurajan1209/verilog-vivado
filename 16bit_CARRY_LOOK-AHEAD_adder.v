module CLA_16bit_Clocked (
    input clk,
    input [15:0] A, B,
    input Cin,
    output reg [15:0] Sum,
    output reg Cout
);
    reg [15:0] a_r, b_r;
    reg cin_r;
    wire [15:0] P, G;
    wire [16:0] C;
    wire [15:0] sum_w;

    always @(posedge clk) begin
        a_r <= A; b_r <= B; cin_r <= Cin;
    end

    // Precompute P and G
    assign P = a_r ^ b_r;
    assign G = a_r & b_r;
    assign C[0] = cin_r;

    // Combinational Lookahead Logic (Simplified flattened visualization for 16-bit)
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : cla_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
            assign sum_w[i] = P[i] ^ C[i];
        end
    endgenerate

    always @(posedge clk) begin
        Sum <= sum_w;
        Cout <= C[16];
    end
endmodule
