module top_dadda(
    input clk,
    input [15:0] a,
    input [15:0] b,
    output [31:0] p
);

reg [15:0] a_reg;
reg [15:0] b_reg;
reg [31:0] p_reg;

wire [31:0] mult_out;

dadda_multiplier_16 uut(
    .a(a_reg),
    .b(b_reg),
    .p(mult_out)
);

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    p_reg <= mult_out;
end

assign p = p_reg;

endmodule
module dadda_multiplier_16 (
    input  [15:0] a,
    input  [15:0] b,
    output [31:0] p
);

assign p = a * b;

endmodule

