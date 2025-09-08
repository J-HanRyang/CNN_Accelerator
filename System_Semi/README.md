# System Semiconductor Design Final Project
CNN Accelerator

## **⚡ Overview :**
This project involves the design and implementation of a CNN accelerator in Verilog. <br>
The primary goal was to overcome the performance bottlenecks of convolution operations by applying a parallel architecture and enhancing the core MAC unit.

## **🛠 Tools :**
Verilog, OpenROAD

## **🏛️ Architecture :**
The final architecture consists of a **convolver** controlling parallel MAC devices. <br>
This design is structured to efficiently perform a 5x5 convolution on a 98x98 image.

## **📜 Results :**
Achieved significant performance improvement by implementing a parallel MAC unit featuring Booth's algorithm multipliers and a Carry-Save Adder (CSA) tree. <br>
Functional correctness was verified through a testbench simulation in Ncverilog, which completed in 105,815 cycles.

<br>

#### *Referenced Document*
[Docs](https://github.com/J-HanRyang/CNN_Accelerator/tree/main/System_Semi/Docs)
