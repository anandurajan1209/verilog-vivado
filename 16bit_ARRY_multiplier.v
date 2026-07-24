module array_multiplier_16 (	
    input  [15:0] A, B,
    output [31:0] Product
);
    wire [15:0] pp [15:0];       // partial products
    wire [31:0] sum [14:0];      // intermediate row sums
    wire [31:0] carry_out;       // unused carries (absorbed)

    genvar i, j;

    // Generate partial products: pp[i][j] = A[j] & B[i]
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_pp
            for (j = 0; j < 16; j = j + 1) begin : gen_bit
                assign pp[i][j] = A[j] & B[i];
            end
        end
    endgenerate

    // Row 0 is the first partial product (shift 0)
    assign sum[0] = {{16{1'b0}}, pp[0]};

    // Add each shifted partial product to the running sum
    generate
        for (i = 1; i < 15; i = i + 1) begin : gen_add
            assign sum[i] = sum[i-1] + ({16'b0, pp[i]} << i);
        end
    endgenerate

    assign Product = sum[14] + ({16'b0, pp[15]} << 15);
endmodule

module TopArrayMultiplier16(
    input        clk,
    input  [15:0] A, B,
    output reg [31:0] Product
);
    wire [31:0] product_wire;

    array_multiplier_16 uut (
        .A(A),
        .B(B),
        .Product(product_wire)
    );

    always @(posedge clk)
        Product <= product_wire;
endmodule


