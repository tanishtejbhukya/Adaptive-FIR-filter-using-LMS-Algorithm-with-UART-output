# Adaptive-FIR-filter-using-LMS-Algorithm-with-UART-output
FPGA implementation of LMS-based adaptive FIR filter with UART output on Artix-7

## 📌 Overview
This project implements an LMS-based adaptive FIR filter on FPGA (EDGE Artix-7).  
The system takes input signals, processes them using an adaptive filter, and transmits the output and error values via UART to a serial terminal (PuTTY).

---

## ⚙️ Key Features
- 4-tap FIR filter implementation
- LMS (Least Mean Squares) adaptive algorithm
- Fixed-point arithmetic (Q4.12 format)
- Real-time UART output display
- Implemented on Xilinx Artix-7 FPGA

---

## 🧠 LMS Algorithm
The LMS algorithm updates filter weights using:

w(n+1) = w(n) + μ · e(n) · x(n)

Where:
- μ → Step size (learning rate)
- e(n) → Error signal
- x(n) → Input signal

This allows the filter to adapt and minimize error over time.

---

## 🖥️ Hardware Details
- FPGA Board: Artix-7 (XC7A35T)
- Clock Frequency: 50 MHz
- UART Baud Rate: 9600
- Interface: USB-UART → PuTTY

---

## 📂 Project Structure
1. Generate input signal using MATLAB
2. Apply input to LMS filter (simulation)
3. Observe adaptation of weights and error reduction
4. Synthesize design on FPGA
5. Display output on PuTTY via UART

---

## 📺 Output (PuTTY)
Example output:
Y=0A40 E=0080
Y=0A60 E=0040
Y=0A80 E=0020
...
- Y → Filter output  
- E → Error (gradually decreases)

---

---

## 📊 Simulation Result
- Error decreases over iterations
- Filter weights converge
- Output approximates desired signal

---

## 🚀 Applications
- Noise cancellation
- System identification
- Signal processing
- Adaptive filtering systems

---

## 👨‍💻 Author
Tanish Tej

---

## ⭐ Notes
This project demonstrates a complete flow from MATLAB simulation to FPGA implementation with real-time UART output.
