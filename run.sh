#!/usr/bin/env sh

#python3 generate_data.py
iverilog -o simulation operations_tb.v operations.v
vvp simulation
#python3 compare_output.py
