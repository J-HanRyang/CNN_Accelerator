# CNN HW RTL CODE

## **cnn_kernel :**
The fundamental, reusable building block that performs the 3x3 Multiply-Accumulate (MAC) operation for a single input channel.

## **cnn_acc_ci :**
The intermediate module that acts as an accumulator across all input channels by instantiating multiple **cnn_kernel** units in parallel.

## **cnn_core :**
The top-level module that orchestrates the entire process for all output channels, calling **cnn_acc_ci** units and adding the final bias values.

## **defines_cnn_core.vh :**
A header file that defines key parameters for the design, such as the number of input/output channels (CI/CO) and kernel dimensions, making the architecture easily configurable.
