`timescale 1ns / 1ps

module booth_multiplier_16 (
    input signed [15:0] A,     // Multiplicand
    input signed [15:0] B,     // Multiplier
    output reg signed [31:0] P // 32-bit Product
);

    reg signed [31:0] partial_product [7:0];
    reg [16:0] B_padded;
    reg signed [31:0] A_ext;
    integer i;

    always @(*) begin
        // Pad the multiplier with a 0 at the LSB for the first overlapping bit
        B_padded = {B, 1'b0};
        
        // Sign-extend the multiplicand to 32 bits to prevent overflow
        A_ext = {{16{A[15]}}, A}; 
        
        // Initialize product to 0
        P = 32'd0;

        // Loop through 8 partial products (16-bit Radix-4 halves the steps)
        for (i = 0; i < 8; i = i + 1) begin
            // Check the 3-bit window
            case (B_padded[(i*2) +: 3])
                3'b000, 3'b111: partial_product[i] = 32'd0;
                3'b001, 3'b010: partial_product[i] = A_ext;
                3'b011:         partial_product[i] = A_ext << 1;     // +2A
                3'b100:         partial_product[i] = -(A_ext << 1);  // -2A
                3'b101, 3'b110: partial_product[i] = -A_ext;         // -1A
                default:        partial_product[i] = 32'd0;
            endcase
            
            // Shift the generated partial product by 2*i and add to the total
            P = P + (partial_product[i] << (2 * i));
        end
    end
endmodule

module top (
    input clk,
    input [15:0] a,
    input [15:0] b,
    output reg [31:0] p
);

reg [15:0] a_reg;
reg [15:0] b_reg;

wire [31:0] mult_out;

wallace_multiplier_16 uut (
    .a(a_reg),
    .b(b_reg),
    .p(mult_out)
);

always @(posedge clk)
begin
    a_reg <= a;
    b_reg <= b;
    p <= mult_out;
end

endmodule
module top (
    input clk,
    input [15:0] a,
    input [15:0] b,
    output reg [31:0] p
);

reg [15:0] a_reg;
reg [15:0] b_reg;

wire [31:0] mult_out;

wallace_multiplier_16 uut (
    .a(a_reg),
    .b(b_reg),
    .p(mult_out)
);

always @(posedge clk)
begin
    a_reg <= a;
    b_reg <= b;
    p <= mult_out;
end

endmodule

