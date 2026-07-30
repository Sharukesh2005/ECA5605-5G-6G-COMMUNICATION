import random
import numpy as np
import matplotlib.pyplot as plt

# Simulation Parameters
num_users = 50
simulation_time = 100
cell_radius = 100

handover_count = 0
handover_delay = []
throughput = []
signaling_load = []
failed_handovers = 0

for t in range(simulation_time):

    for user in range(num_users):

        position = random.randint(0, 300)

        if position > cell_radius:

            handover_count += 1

            delay = random.uniform(20, 80)
            handover_delay.append(delay)

            data = random.uniform(5, 15)
            throughput.append(data)

            signaling = random.randint(4, 10)
            signaling_load.append(signaling)

            if random.random() < 0.1:
                failed_handovers += 1

# Calculate Results
avg_delay = np.mean(handover_delay)
avg_throughput = np.mean(throughput)
avg_signal = np.mean(signaling_load)

failure_probability = failed_handovers / handover_count

# ===============================
# Save Console Output
# ===============================

output = f"""
Simulation Results
----------------------
Handover Count = {handover_count}
Average Delay = {avg_delay:.2f} ms
Average Throughput = {avg_throughput:.2f} Mbps
Average Signaling Load = {avg_signal:.2f} messages
Failure Probability = {failure_probability:.3f}
"""

print(output)

with open("simulation_output.txt", "w") as file:
    file.write(output)

print("Output saved as simulation_output.txt")

# ===============================
# Graph 1
# ===============================

plt.figure(figsize=(10,5))

plt.subplot(1,2,1)
plt.bar(["Count"], [handover_count])
plt.title("Handover Count")

plt.subplot(1,2,2)
plt.bar(["Failure"], [failure_probability])
plt.title("Failure Probability")

plt.tight_layout()

plt.savefig("Performance_Metrics.png", dpi=300)

plt.show()

# ===============================
# Graph 2
# ===============================

plt.figure(figsize=(10,5))

plt.plot(handover_delay, label="Delay")
plt.plot(throughput, label="Throughput")

plt.xlabel("Handovers")
plt.ylabel("Value")
plt.legend()
plt.grid(True)

plt.savefig("Delay_Throughput.png", dpi=300)

plt.show()

print("Graphs saved successfully.")