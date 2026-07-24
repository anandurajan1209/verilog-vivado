
module CSA_16bit_Clocked (
    input clk,
    input [15:0] A, B,
    input Cin,
    output reg [15:0] Sum,
    output reg Cout
);
    reg [15:0] a_r, b_r;
    reg cin_r;
    wire [15:0] sum_0, sum_1;
    wire [3:0] c_out_0, c_out_1;
    wire [3:0] c_sel;
    wire [15:0] sum_final;

    always @(posedge clk) begin
        a_r <= A; b_r <= B; cin_r <= Cin;
    end

    // Block 0: Direct calculation (Bits 3:0)
    assign {c_sel[0], sum_final[3:0]} = a_r[3:0] + b_r[3:0] + cin_r;

    // Blocks 1-3: Dual computations (Bits 15:4)
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : csa_blocks
            // Calculate assuming Cin = 0
            assign {c_out_0[i], sum_0[4*i+3 : 4*i]} = a_r[4*i+3 : 4*i] + b_r[4*i+3 : 4*i] + 1'b0;
            // Calculate assuming Cin = 1
            assign {c_out_1[i], sum_1[4*i+3 : 4*i]} = a_r[4*i+3 : 4*i] + b_r[4*i+3 : 4*i] + 1'b1;
            
            // MUX selection based on previous block's actual carry out
            assign sum_final[4*i+3 : 4*i] = (c_sel[i-1]) ? sum_1[4*i+3 : 4*i] : sum_0[4*i+3 : 4*i];
            assign c_sel[i] = (c_sel[i-1]) ? c_out_1[i] : c_out_0[i];
        end
    endgenerate

    always @(posedge clk) begin
        Sum <= sum_final;
        Cout <= c_sel[3];
    end
endmodule
