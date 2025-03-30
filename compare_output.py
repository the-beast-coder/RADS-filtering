#!/usr/bin/env python3

import matplotlib.pyplot as plt

# Read the filtered output from the simulation.
with open("filtered_output.txt", "r") as f:
    filtered = [float(line.strip()) / (2**8) for line in f.readlines()]

# Read the true displacement values.
with open("true_data.txt", "r") as f:
    true_disp = [float(line.strip()) for line in f.readlines()]

# Create a time axis (for example, each index corresponds to a time step)
time_steps = list(range(len(true_disp)))

plt.figure()
plt.plot(time_steps, true_disp, label="True Displacement", marker='o')
plt.plot(time_steps, filtered, label="Filtered Output (Kalman)", marker='x')
plt.xlabel("Time Step")
plt.ylabel("Displacement")
plt.title("Comparison of True Displacement and Kalman Filter Output")
plt.legend()
plt.grid(True)
plt.show()
