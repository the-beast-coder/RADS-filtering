// Matrices operations

module matrix_mult_2x1_1x2 (
    input  signed [15:0] m0, m1,   // 2x1 matrix elements (column vector)
    input  signed [15:0] n0, n1,   // 1x2 matrix elements (row vector)
    output signed [15:0] r00, r01, // Resulting 2x2 matrix elements
    output signed [15:0] r10, r11
);
    // Outer product:
    // [ m0 ] * [ n0  n1 ] = [ m0*n0   m0*n1 ]
    // [ m1 ]                [ m1*n0   m1*n1 ]
    fixed_point_mul mul_r00 (.a(m0), .b(n0), .result(r00));
    fixed_point_mul mul_r01 (.a(m0), .b(n1), .result(r01));
    fixed_point_mul mul_r10 (.a(m1), .b(n0), .result(r10));
    fixed_point_mul mul_r11 (.a(m1), .b(n1), .result(r11));
endmodule


module matrix_mult_1_2x1 (
    input  signed [15:0] scalar,   // Scalar multiplier (1x1)
    input  signed [15:0] m0, m1,     // 2x1 matrix elements (column vector)
    output signed [15:0] r0, r1      // Resulting 2x1 matrix
);
    // Multiply the scalar with each element of the 2x1 matrix.
    fixed_point_mul mul_r0 (.a(scalar), .b(m0), .result(r0));
    fixed_point_mul mul_r1 (.a(scalar), .b(m1), .result(r1));
endmodule


module matrix_mult_2x2_2x1 (
    input  signed [15:0] a, b, c, d,  // 2x2 matrix elements
    input  signed [15:0] e, f,        // 2x1 matrix (column vector)
    output signed [15:0] r0, r1       // Resulting 2x1 matrix
);
    wire signed [15:0] prod_ae, prod_bf, prod_ce, prod_df;

    fixed_point_mul mul_ae (.a(a), .b(e), .result(prod_ae));
    fixed_point_mul mul_bf (.a(b), .b(f), .result(prod_bf));
    fixed_point_mul mul_ce (.a(c), .b(e), .result(prod_ce));
    fixed_point_mul mul_df (.a(d), .b(f), .result(prod_df));

    fixed_point_add add_r0 (.a(prod_ae), .b(prod_bf), .result(r0));
    fixed_point_add add_r1 (.a(prod_ce), .b(prod_df), .result(r1));
endmodule


module matrix_add_2x2 (
    input  signed [15:0] a1, b1, c1, d1,  // Matrix A elements
    input  signed [15:0] a2, b2, c2, d2,  // Matrix B elements
    output signed [15:0] a_out, b_out, c_out, d_out  // Sum matrix elements
);

    // Element–wise addition using fixed–point addition modules.
    fixed_point_add add00 (.a(a1), .b(a2), .result(a_out));
    fixed_point_add add01 (.a(b1), .b(b2), .result(b_out));
    fixed_point_add add10 (.a(c1), .b(c2), .result(c_out));
    fixed_point_add add11 (.a(d1), .b(d2), .result(d_out));

endmodule

module matrix_transpose_2x2 (
    input  signed [15:0] a, b, c, d,  // Original matrix A elements
    output signed [15:0] at, bt, ct, dt  // Transposed matrix elements
);
    // Transpose assignments:
    // at = a, bt = c, ct = b, dt = d.
    assign at = a;
    assign bt = c;
    assign ct = b;
    assign dt = d;
endmodule

module matrix_mult_2x2 (
    input  signed [15:0] a, b, c, d,  // Matrix A elements: [a  b; c  d]
    input  signed [15:0] e, f, g, h,  // Matrix B elements: [e  f; g  h]
    output signed [15:0] r00, r01, r10, r11  // Result matrix elements
);

    // Wires for the intermediate products.
    wire signed [15:0] prod_ae, prod_bg, prod_af, prod_bh;
    wire signed [15:0] prod_ce, prod_dg, prod_cf, prod_dh;

    // Compute products for each partial term.
    fixed_point_mul mul_ae (.a(a), .b(e), .result(prod_ae));
    fixed_point_mul mul_bg (.a(b), .b(g), .result(prod_bg));
    fixed_point_mul mul_af (.a(a), .b(f), .result(prod_af));
    fixed_point_mul mul_bh (.a(b), .b(h), .result(prod_bh));
    fixed_point_mul mul_ce (.a(c), .b(e), .result(prod_ce));
    fixed_point_mul mul_dg (.a(d), .b(g), .result(prod_dg));
    fixed_point_mul mul_cf (.a(c), .b(f), .result(prod_cf));
    fixed_point_mul mul_dh (.a(d), .b(h), .result(prod_dh));

    // Sum the partial products for each output element.
    fixed_point_add add_r00 (.a(prod_ae), .b(prod_bg), .result(r00));
    fixed_point_add add_r01 (.a(prod_af), .b(prod_bh), .result(r01));
    fixed_point_add add_r10 (.a(prod_ce), .b(prod_dg), .result(r10));
    fixed_point_add add_r11 (.a(prod_cf), .b(prod_dh), .result(r11));

endmodule

module matrix_inverse_2x2 (
    input  signed [15:0] a, b, c, d,  // Input matrix A: [a  b; c  d]
    output signed [15:0] inv00, inv01, inv10, inv11  // Inverse matrix elements:
    // inv00 = d/det, inv01 = -b/det, inv10 = -c/det, inv11 = a/det
);

    // Wires for intermediate values.
    wire signed [15:0] prod_ad, prod_bc;
    wire signed [15:0] det;

    // Compute the products for the determinant.
    fixed_point_mul mul_ad (.a(a), .b(d), .result(prod_ad));
    fixed_point_mul mul_bc (.a(b), .b(c), .result(prod_bc));
    // Determinant = a*d - b*c.
    fixed_point_sub sub_det (.a(prod_ad), .b(prod_bc), .result(det));

    // Compute each element of the inverse using the division module.
    fixed_point_div div_inv00 (.a(d),   .b(det), .result(inv00));
    fixed_point_div div_inv01 (.a(-b),  .b(det), .result(inv01));
    fixed_point_div div_inv10 (.a(-c),  .b(det), .result(inv10));
    fixed_point_div div_inv11 (.a(a),   .b(det), .result(inv11));

endmodule

module fixed_point_add (
    input  signed [15:0] a,  // 8.8 fixed-point input
    input  signed [15:0] b,  // 8.8 fixed-point input
    output signed [15:0] result  // 8.8 fixed-point result
);
    // Addition works directly since both numbers share the same scaling
    assign result = a + b;
endmodule

module fixed_point_sub (
    input  signed [15:0] a,  // 8.8 fixed-point input
    input  signed [15:0] b,  // 8.8 fixed-point input
    output signed [15:0] result  // 8.8 fixed-point result
);
    // Subtraction works directly as well
    assign result = a - b;
endmodule

module fixed_point_mul (
    input  signed [15:0] a,  // 8.8 fixed-point input
    input  signed [15:0] b,  // 8.8 fixed-point input
    output signed [15:0] result  // 8.8 fixed-point result
);
    // Multiplying two 16-bit numbers gives a 32-bit product.
    // Since both inputs are scaled by 256, the product has an extra factor of 256.
    // A right arithmetic shift of 8 bits restores the 8.8 fixed-point format.
    wire signed [31:0] prod;
    assign prod = a * b;
    assign result = prod >>> 8;
endmodule

module fixed_point_div (
    input  signed [15:0] a,  // 8.8 fixed-point dividend
    input  signed [15:0] b,  // 8.8 fixed-point divisor
    output reg signed [15:0] result  // 8.8 fixed-point result
);
    // Widen the dividend to 32 bits with sign-extension before shifting.
    reg signed [31:0] dividend;
    always @(*) begin
        if (b == 0) begin
            // Handle division by zero by returning maximum positive value.
            result = 16'h7FFF;
        end else begin
            // Sign-extend 'a' to 32 bits and shift left by 8 bits.
            dividend = { {16{a[15]}}, a } << 8;
            result = dividend / b;
        end
    end
endmodule
