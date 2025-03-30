
module tb_matrix_operations;

    // Declare Matrix A elements (2x2)
    reg signed [15:0] a, b, c, d;
    // Declare Matrix B elements (2x2)
    reg signed [15:0] a2, b2, c2, d2;

    // Wires for Transpose of A: outputs at, bt, ct, dt
    wire signed [15:0] at, bt, ct, dt;

    // Wires for Matrix Addition (A + B): outputs a_out, b_out, c_out, d_out
    wire signed [15:0] a_add, b_add, c_add, d_add;

    // Wires for Matrix Multiplication (A * B): outputs r00, r01, r10, r11
    wire signed [15:0] r00, r01, r10, r11;

    // Wires for Matrix Inverse of A: outputs inv00, inv01, inv10, inv11
    wire signed [15:0] inv00, inv01, inv10, inv11;

    // Instantiate the 2x2 Transpose module for Matrix A
    matrix_transpose_2x2 u_transpose (
        .a(a), .b(b), .c(c), .d(d),
        .at(at), .bt(bt), .ct(ct), .dt(dt)
    );

    // Instantiate the 2x2 Addition module for A + B
    matrix_add_2x2 u_add (
        .a1(a), .b1(b), .c1(c), .d1(d),
        .a2(a2), .b2(b2), .c2(c2), .d2(d2),
        .a_out(a_add), .b_out(b_add), .c_out(c_add), .d_out(d_add)
    );

    // Instantiate the 2x2 Multiplication module for A * B
    matrix_mult_2x2 u_mult (
        .a(a), .b(b), .c(c), .d(d),
        .e(a2), .f(b2), .g(c2), .h(d2),
        .r00(r00), .r01(r01), .r10(r10), .r11(r11)
    );

    // Instantiate the 2x2 Inverse module for Matrix A
    matrix_inverse_2x2 u_inverse (
        .a(a), .b(b), .c(c), .d(d),
        .inv00(inv00), .inv01(inv01), .inv10(inv10), .inv11(inv11)
    );

    initial begin
        // Initialize Matrix A: [384, 256; -128, 512] => [1.5, 1.0; -0.5, 2.0]
        a = 16'd384;
        b = 16'd256;
        c = -16'd128;
        d = 16'd512;

        // Initialize Matrix B: [256, 384; 512, -128] => [1.0, 1.5; 2.0, -0.5]
        a2 = 16'd256;
        b2 = 16'd384;
        c2 = 16'd512;
        d2 = -16'd128;

        #10; // Wait for operations to settle

        // Display input matrices
        $display("Matrix A:");
        $display("  a = %d, b = %d", a, b);
        $display("  c = %d, d = %d", c, d);
        $display("Matrix B:");
        $display("  a2 = %d, b2 = %d", a2, b2);
        $display("  c2 = %d, d2 = %d", c2, d2);

        // Display Transpose of Matrix A
        $display("\nTranspose of Matrix A:");
        $display("  at = %d, bt = %d", at, bt);
        $display("  ct = %d, dt = %d", ct, dt);

        // Display Matrix Addition (A + B)
        $display("\nMatrix Addition (A + B):");
        $display("  a_out = %d, b_out = %d", a_add, b_add);
        $display("  c_out = %d, d_out = %d", c_add, d_add);

        // Display Matrix Multiplication (A * B)
        $display("\nMatrix Multiplication (A * B):");
        $display("  r00 = %d, r01 = %d", r00, r01);
        $display("  r10 = %d, r11 = %d", r10, r11);

        // Display Matrix Inverse of A
        $display("\nMatrix Inverse of A:");
        $display("  inv00 = %d, inv01 = %d", inv00, inv01);
        $display("  inv10 = %d, inv11 = %d", inv10, inv11);

        #10;
        $finish;
    end

endmodule



/*

module tb_fixed_point_arithmetic;
    reg  signed [15:0] a;
    reg  signed [15:0] b;
    wire signed [15:0] add_result;
    wire signed [15:0] sub_result;
    wire signed [15:0] mul_result;
    wire signed [15:0] div_result;

    // Instantiate the addition module
    fixed_point_add u_add (
        .a(a),
        .b(b),
        .result(add_result)
    );

    // Instantiate the subtraction module
    fixed_point_sub u_sub (
        .a(a),
        .b(b),
        .result(sub_result)
    );

    // Instantiate the multiplication module
    fixed_point_mul u_mul (
        .a(a),
        .b(b),
        .result(mul_result)
    );

    // Instantiate the division module
    fixed_point_div u_div (
        .a(a),
        .b(b),
        .result(div_result)
    );

    initial begin
        $display("Fixed Point Arithmetic (8.8 format) Testbench");

        // Test 1: a = 384 (1.5), b = -128 (-0.5)
        // Expected results:
        //   Addition: 384 + (-128) = 256   → 1.0 in fixed-point
        //   Subtraction: 384 - (-128) = 512  → 2.0 in fixed-point
        //   Multiplication: 384 * (-128) = -49152 >> 8 = -192 → -0.75 in fixed-point
        //   Division: (384 << 8)/(-128) = (98304)/(-128) = -768 → -3.0 in fixed-point
        a = 16'd384;    // 1.5 in fixed-point
        b = -16'd128;   // -0.5 in fixed-point
        #10;
        $display("Test 1:");
        $display("  a = %d, b = %d", a, b);
        $display("  Addition: %d (expected 256)", add_result);
        $display("  Subtraction: %d (expected 512)", sub_result);
        $display("  Multiplication: %d (expected -192)", mul_result);
        $display("  Division: %d (expected -768)", div_result);

        // Test 2: a = 512 (2.0), b = 256 (1.0)
        // Expected results:
        //   Addition: 512 + 256 = 768   → 3.0 in fixed-point
        //   Subtraction: 512 - 256 = 256  → 1.0 in fixed-point
        //   Multiplication: 512 * 256 = 131072 >> 8 = 512 → 2.0 in fixed-point
        //   Division: (512 << 8)/256 = (131072)/256 = 512 → 2.0 in fixed-point
        a = 16'd512;    // 2.0 in fixed-point
        b = 16'd256;    // 1.0 in fixed-point
        #10;
        $display("\nTest 2:");
        $display("  a = %d, b = %d", a, b);
        $display("  Addition: %d (expected 768)", add_result);
        $display("  Subtraction: %d (expected 256)", sub_result);
        $display("  Multiplication: %d (expected 512)", mul_result);
        $display("  Division: %d (expected 512)", div_result);

        // Test 3: Division by zero
        a = 16'd384;
        b = 16'd0;  // Divisor is zero
        #10;
        $display("\nTest 3: Division by Zero");
        $display("  a = %d, b = %d", a, b);
        $display("  Division: %d (expected 32767 or 0x7FFF)", div_result);

        $finish;
    end

endmodule

*/
