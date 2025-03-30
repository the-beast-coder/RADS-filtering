`timescale 1ns / 1ps

// Testbench for the dummy Kalman Filter.
module tb_kalman_filter;
    parameter DATA_WIDTH = 16;
    parameter N = 50; // number of data points

    reg clk;
    reg [DATA_WIDTH-1:0] measurement;
    wire [DATA_WIDTH-1:0] filtered;

    // Instantiate the dummy Kalman Filter.
    kalman_filter uut (
        .measurement(measurement),
        .filtered(filtered)
    );

    // Memory to hold the measurement data (read from file).
    reg [DATA_WIDTH-1:0] meas_data [0:N-1];
    integer i;
    integer outfile;

    initial begin
        // Read measurement data from file (in hexadecimal format)
        $readmemh("meas_data.txt", meas_data);
        // Open file to write the filter output.
        outfile = $fopen("filtered_output.txt", "w");

        // Apply each measurement value to the Kalman filter.
        for (i = 0; i < N; i = i + 1) begin
            measurement = meas_data[i];
            #10; // wait for the filter to process the input
            // Write the filtered output as a decimal number.
            $fwrite(outfile, "%d\n", filtered);
        end

        $fclose(outfile);
        $finish;
    end

    // optional clock generation
    initial clk = 0;
    always #5 clk = ~clk;
endmodule
