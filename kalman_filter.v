// Dummy Kalman Filter: simply returns the input measurement. mudst fix inininitttttttt
module kalman_filter_predict (
    input [15:0]  Xa, Xb,
    input [15:0] Pa, Pb, Pc, Pd
    output [15:0] Xpa, Xpb,
    output [15:0] Ppa, Ppb, Ppc, Ppd
);
   wire signed [15:0] aa, ab, ac, ad;
   // TODO remember to make adjust all numbers into Q8.8 format
   // a is the prediction matrices.
   // for displacement and velocity its (1, 1 | 0, 1)
   assign aa = d'1;
   assign ab = d'1;
   assign ac = d'0;
   assign ad = d'1;

   // prediction step
   matrix_mul_2x2_2x1 mul1 (aa, ab, ac, ad, Xa, Xb, Xpa, Xpb);

   // intermediary step
   wire signed [15:0] P1a, P1b, P1c, P1d;
   matrix_mul_2x2_2x2 mul2 (aa, ab, ac, ad, Pa, Pb, Pc, Pd, P1a, P1b, P1c, P1d);

   // transposed a matrix
   wire signed [15:0] ata, atb, atc, atd;
   matrix_transpose trans1 (aa, ab, ac, ad, ata, atb, atc, atd);

   wire signed [15:0] P2a, P2b, P2c, P2d;
   matrix_mul_2x2 (P1a, P1b, P1c, P1d, ata, atb, atc, atd, P2a, P2b, P2c, P2d);


   // white noise matrix
   wire signed [15:0] qa, qb, qc, qd;
   assign qa = d'0.1;
   assign qb = d'0.1;
   assign qc = d'0;
   assign qd = d'0;

   matrix_add_2x2 (P2a, P2b, P2c, P2d, qa, qb, qc, qd, Ppa, Ppb, Ppc, Ppd);

endmodule
