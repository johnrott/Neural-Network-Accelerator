# FPGA Neural Network Matrix Accelerator

This project implements a 3×3 matrix multiplication accelerator on an Artix-7 FPGA (Digilent Cora Z7-07S).
It performs basic neural network computations and transmits output via UART to an Arduino-controlled 7-segment display.

## Features
- Verilog implementation with controller logic
- Tested using Vivado simulation
- UART integration for real-time output
- Arduino display and reset functionality

## Hardware
- FPGA: Digilent Cora Z7-07S
- Microcontroller: Arduino Uno
- Display: 3-digit 7-segment
