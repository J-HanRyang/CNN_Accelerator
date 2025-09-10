# Matbi's AI HW CNN Project

## **⚡ Overview :**
This project focuses on designing a hardware core for CNN convolution, based on a C reference model. <br>
The main goal was to create a reference file in C, mapping it to a hierarchical Verilog structure to implement an extensible and reusable hardware architecture. <br>

## **🛠 Tools :**
Verilog, C Languatem, Vivado, Linux

## **🏛️ Architecture :**
The architecture directly mirrors the logical flow of the CNN algorithm in a hierarchical manner(cnn_core → cnn_acc_ci → cnn_kernel) <br>
- The **cnn_kernel** module performs the base MAC operation for a single channel
- **cnn_acc_ci** accumulates results across all input channels
- the top-level **cnn_core** manages the final bias addition and orchestrates the process for all output channels.
<br>

- **cnn_core.c** : This module is the C language reference model. <br>
It serves as the "golden model" that defines the exact behavior of the hardware.


## **📜 Results :**
A clear and scalable hierarchical architecture for a CNN convolution core was successfully designed in Verilog. <br>
A standard hardware/software co-design methodology was established by creating a C-language reference model to generate test vectors and verify the RTL's functional correctness, providing a solid foundation for building a complete and verified accelerator.

<br>

본 프로젝트는 인프런의 '설계독학맛비's 실전 AI HW 설계를 위한 바이블 강의를 수강하며 학습한 내용을 기반으로 합니다. <br>
본 자료는 포트폴리오 목적으로 공개하며, 과제 표절 등 비윤리적 목적으로 사용될 수 없습니다.
