# **CNN Accelerator Modules**

## **Convolver :**
The top-level module and FSM controller. <br>
It orchestrates the entire convolution process, including managing data flow, <br>
efficiently shifting the image window (SHIFT), loading data into internal RAMs (LOAD), and controlling the MAC unit.

## **MAC :**
A high-performance Multiply-Accumulate unit. <br>
It instantiates 25 Booth Multiplier modules and one 25-input CSA Tree to process the 25 multiply-accumulate operations of a 5x5 filter in a highly parallel manner, significantly improving the core calculation speed.

## **Booth & CSA :**
The core computational building blocks. **Booth** implements an efficient 8-bit signed multiplier using Booth's algorithm. <br>
CSA.v implements a high-speed Carry-Save Adder tree to sum the 25 partial products from the multipliers with minimal delay.
