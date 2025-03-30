import numpy as np
import matplotlib.pyplot as plt

# Simulation parameters
dt = 1.0                # time step
N = 50                  # number of time steps
true_velocity = 1.0     # constant velocity
true_initial_position = 0.0

# Generate true positions assuming constant velocity.
true_positions = np.array([true_initial_position + i * true_velocity for i in range(N)])

# Simulate noisy displacement measurements.
measurement_noise_std = 2.0
measurements = true_positions + np.random.normal(0, measurement_noise_std, size=N)

# Kalman Filter Setup for constant velocity model:
# State vector: x = [position, velocity]^T
# State transition matrix: F = [[1, dt],
#                               [0,  1]]
# Measurement matrix: H = [1, 0] (we only measure position)
F = np.array([[1, dt],
              [0, 1]])
H = np.array([[1, 0]])

# Process noise covariance matrix Q (assume small process noise)
q = 0.1
Q = np.array([[q, 0],
              [0, q]])
# Measurement noise covariance matrix R
R = np.array([[measurement_noise_std**2]])

# Initial state estimate and covariance
x_est = np.array([0, 0])  # initial guess: starting at 0 with zero velocity
P_est = np.eye(2)

# Lists to store the Kalman filter estimates
estimates = []

# Kalman Filter loop
for z in measurements:
    # --- Prediction ---
    x_pred = F @ x_est
    P_pred = F @ P_est @ F.T + Q

    # --- Update ---
    # Innovation (measurement residual)
    y = z - (H @ x_pred)
    # Innovation covariance
    S = H @ P_pred @ H.T + R
    # Kalman gain
    K = P_pred @ H.T @ np.linalg.inv(S)
    # Updated state estimate
    x_est = x_pred + (K * y).flatten()
    # Updated estimate covariance
    P_est = (np.eye(2) - K @ H) @ P_pred

    estimates.append(x_est.copy())

estimates = np.array(estimates)

# Plotting results
plt.figure(figsize=(10, 6))
plt.plot(true_positions, label="True Position", linewidth=2)
plt.plot(measurements, 'o', label="Measured Position", markersize=4)
plt.plot(estimates[:, 0], label="Kalman Filter Estimate", linewidth=2)
plt.xlabel("Time Step")
plt.ylabel("Position")
plt.title("Kalman Filter: True Position vs. Measurements vs. Estimates")
plt.legend()
plt.grid(True)
plt.show()
