#!/usr/bin/env python3

import random

# Parameters for the simulated system
N = 50          # Number of data points
velocity = 0.1     # Constant velocity: displacement increases linearly
noise_range = 1

with open("meas_data.txt", "w") as f_meas, open("true_data.txt", "w") as f_true:
    for i in range(N):
        true_val = i * velocity
        # Add random noise to the true displacement
        noise = random.random() * noise_range - noise_range * 0.5
        meas_val = true_val + noise
        if meas_val < 0:
            meas_val = -meas_val

        # Write the measurement in 8-digit hexadecimal format.
        print(int(meas_val * float(2**8)))
        f_meas.write("{:04X}\n".format(int(meas_val  * float(2**8)) & 0xffff))
        # Write the true displacement as a decimal number.
        f_true.write(f"{true_val}\n")
