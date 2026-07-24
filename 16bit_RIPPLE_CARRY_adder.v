module ripple_carry_adder16 (
    input clk,
    input [15:0] A, B,
    input Cin,
    output reg [15:0] Sum,
    output reg Cout
);
    reg [15:0] a_r, b_r;
    reg cin_r;
    wire [15:0] sum_w;
    wire [16:0] c_w;
    
    // Input flops
    always @(posedge clk) begin
        a_r <= A; b_r <= B; cin_r <= Cin;
    end

    assign c_w[0] = cin_r;
    
    // Combinational Ripple Chain
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : rca_gen
            assign sum_w[i] = a_r[i] ^ b_r[i] ^ c_w[i];
            assign c_w[i+1] = (a_r[i] & b_r[i]) | (c_w[i] & (a_r[i] ^ b_r[i]));
        end
    endgenerate

    // Output flops
    always @(posedge clk) begin
        Sum <= sum_w;
        Cout <= c_w[16];
    end
endmodule
