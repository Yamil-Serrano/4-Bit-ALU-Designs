# 4-Bit ALU Designs

A collection of 4-bit ALU designs exploring contrasting architectural philosophies, from a minimalist NAND‑universal implementation to a more advanced carry‑lookahead architecture. The first design is a hardware‑minimalist ALU, built entirely with discrete ICs, real wiring, and breadboards. It demonstrates how complete arithmetic and logic behavior can emerge from simple components using NAND universality and ripple‑carry techniques. The second design is a more complete and high‑performance ALU, featuring carry‑lookahead logic (CLA) and additional dedicated logic blocks.

# Hardware-Minimalist 4-bit ALU (Ripple-Carry Architecture)
This ALU represents the most fundamental version of the project: a design built entirely from discrete logic ICs, assembled by hand using breadboards, wiring, and basic digital components. The core idea is to show how a complete arithmetic and logic system can emerge from a minimal set of building blocks, following the principles of NAND universality and simple ripple-carry computation.

At its heart, this design implements a 4-bit ripple-carry adder, where each bit calculates its sum and pass its carry to the next stage. While not the fastest architecture, its transparency makes it highly educational: every step of the computation from XOR-based addition to AND-driven carry generation is physically observable in the circuit.

Beyond addition and subtraction, the ALU includes a NAND-based logic path to highlight how a single universal gate can serve as the foundation for more complex operations. The result is a compact but fully functional ALU that exemplifies hardware minimalism, discrete logic design, and hands-on digital engineering.

## Technical Specifications

### Core Features
- **Data Width**: 4-bit parallel processing
- **Operations**: 
  - `00` - Bitwise NAND (A NAND B)
  - `01` - Arithmetic addition (A + B)
  - `11` - Arithmetic subtraction (A - B) using two's complement
- **Control Input**: 2-bit operation code
- **Output Flags**: 
  - **Carry Out** - For arithmetic overflow detection
  - **Zero Flag** - Indicates when result equals 0000
- **Design Philosophy**: Hardware minimalism via NAND universality

## Integrated Circuits Used
| IC | Function | Quantity | Purpose |
|----|----------|----------|---------|
| **74HC86** | Quad XOR Gate | 4 | Full adder implementation and two's complement |
| **74HC08** | Quad AND Gate | 2 | Carry generation for arithmetic operations |
| **74HC00** | Quad NAND Gate | 1 | NAND operation and control logic |
| **74HC157** | 2:1 Multiplexer | 1 | Operation selection and output routing |
| **CD4000** | 2x 3-input NOR + NOT gates | 1 | Zero flag detection logic |

**Total Components**: 9 ICs, implementing a complete 4-bit ALU

## Hardware Implementation

### Circuit Design
<img width="4140" height="3090" alt="Main" src="https://github.com/user-attachments/assets/b60e6d25-3f0f-4892-bed9-4a970c2f09d8" />
*Complete circuit schematic designed in CircuitVerse*

## Operation Details

#### 1. **Addition (01)**
- Implements 4-bit ripple-carry adder
- Uses XOR gates for sum, AND gates for carry
- Direct A + B computation

#### 2. **Subtraction (11)**
- Utilizes two's complement method
- Inverts B using XOR gates (B ⊕ 1)
- Adds 1 via carry-in for proper complement
- Result: A + (~B + 1) = A - B

#### 3. **NAND Operation (00)**
- Direct NAND gate implementation
- Demonstrates NAND universality principle
- Basis for emulating all other logic operations

### Flag Generation

#### **Zero Flag**
- Implemented using NOR logic reduction via CD4000
- Detects when all 4 result bits are 0
- Output: HIGH when result = 0000

#### **Carry Flag**
- Generated from the 4th full adder's carry-out
- Indicates arithmetic overflow in addition/subtraction

## Truth Table Examples

| A (bin) | B (bin) | Op | Result | Carry | Zero |
|---------|---------|----|--------|-------|------|
| 0101    | 0011    | 01 (Add) | 1000 | 0 | 0 |
| 0111    | 0010    | 11 (Sub) | 0101 | 1 | 0 |
| 1111    | 1111    | 00 (NAND) | 0000 | X | 1 |
| 0000    | 0000    | 01 (Add) | 0000 | 0 | 1 |

## Educational Value

This project demonstrates fundamental computer architecture concepts:

1. **NAND Universality**: All digital logic can be constructed from NAND gates
2. **Two's Complement Arithmetic**: How computers perform subtraction
3. **Hardware/Software Trade-off**: Why some operations are emulated in software
4. **Flag-Based Computing**: Essential for conditional operations in CPUs
5. **Ripple-Carry Design**: Basic but functional adder architecture

### Breadboard Implementation
![Breadboard](https://github.com/user-attachments/assets/11e9838c-7574-48a2-95e6-e5d097de726d)
*Close-up of the wired implementation*

## Building Your Own

### Components List

| Quantity | Component | Specification | Use in ALU |
|----------|-----------|---------------|------------|
| 4        | 74HC86    | Quad XOR Gate | Full adder and two's complement |
| 2        | 74HC08    | Quad AND Gate | Carry generation for arithmetic operations |
| 1        | 74HC00    | Quad NAND Gate | NAND operation and control logic |
| 1        | 74HC157   | 4-bit 2:1 Multiplexer | Operation selection |
| 1        | CD4000    | 2x 3-input NOR + NOT gates | Zero flag detection |
| 8        | LEDs      | Yellow, 5mm | Input bits (A and B, 4 each) |
| 4        | LEDs      | Red, 5mm | ALU result (4-bit output) |
| 1        | LED       | Green, 5mm | Zero flag indicator |
| 2        | LEDs      | Blue, 5mm | Operation code indicators |
| 11       | Resistors | 330Ω, 1/4W | Current limiting for LEDs |
| 2        | Breadboards | 830+ points | Circuit prototyping |
| 50+      | Jumper wires | Various colors | Circuit connections |
| 1        | Power supply | 5V DC, 1A minimum | Circuit power supply |

### Construction Tips
1. Start with power distribution (VCC and GND rails)
2. Implement full adder for one bit first, then replicate bottom-up
3. Test each operation individually before full integration
4. Use consistent color coding for signals

## ⚠️ Known Limitations

1. **Propagation Delay**: Ripple-carry design limits maximum speed
2. **Limited Operations**: Only 3 hardware operations
3. **No Overflow Flag**: Signed overflow detection not implemented
4. **Manual Testing**: Requires external input/output devices

# Advanced 4-Bit ALU (Carry-Lookahead Architecture)

After the hand-wired model, a second version was engineered using **Carry-Lookahead Logic (CLA)** to dramatically reduce propagation delay. In a ripple-carry adder, each bit must wait for the previous carry — limiting speed. 

<img width="7577" height="4865" alt="Main" src="https://github.com/user-attachments/assets/e9e5bc63-5055-4dbc-ac76-90e643e89c14" />
*Complete circuit schematic designed in CircuitVerse*

## Technical Specifications
Instead of letting each bit wait for the previous carry, the CLA computes all carries in parallel using the classical Generate and Propagate signals:

- Gi = AND(Ai, Bi)
- Pi = XOR(Ai, Bi)

From these, every carry is derived combinationally:

- C1 = OR( G0, AND(P0, Cin) )
- C2 = OR( G1, AND(P1, G0), AND(P1, P0, Cin) )
- C3 = OR( G2, AND(P2, G1), AND(P2, P1, G0), AND(P2, P1, P0, Cin) )
- C4 = OR( G3, AND(P3, G2), AND(P3, P2, G1), AND(P3, P2, P1, G0), AND(P3, P2, P1, P0, Cin) )

### Benefits of the CLA Design
- Much faster than ripple-carry  
- All carries computed in one combinational layer  
- More scalable (easy to extend to 8 or 16 bits)  

### Additional Logic Operations Added
The new Architecture also adds three independent logic blocks:

- **NAND**  
- **NOR**  
- **XNOR**  


# FPGA Implementation: Tang Nano 9K
This module ports the 4-bit ALU logic from discrete integrated circuits to a programmable Gowin GW1NR-LV9 FPGA on the Sipeed Tang Nano 9K board. This transformation demonstrates a key modern digital design workflow: translating a proven hardware concept into a compact, single-chip solution using Hardware Description Language (HDL). The implementation faithfully replicates the behavior of the original breadboard circuit, providing a direct comparison between discrete and programmable logic.

## Physical Prototype & Interfacing
The FPGA interacts with the physical world through a simple, hands-on interface built on a breadboard. This setup mirrors the experience of the discrete version while showcasing the FPGA's role as a universal logic device.

**Input (Switches):**
A robust pull-down configuration is used for all input pins. The circuit guarantees a definite logic high (1) when the switch is pressed and a solid logic low (0) when released, eliminating floating states.

**Output (LEDs):**
Output pins drive LEDs in a standard active-high configuration. An illuminated LED represents a logic high (`1`).

![20251219_232145 1](https://github.com/user-attachments/assets/a3ac4201-116e-4470-bcaf-a03b19d723fd)
*Tang Nano 9K with input switches and output LEDs.*

## Design Philosophy & Notes
- **Architectural Fidelity**: The HDL description was structured to mirror the original ripple-carry data path, providing a clear one-to-one conceptual mapping between the discrete gate-level design and its HDL counterpart.
- **Resource Efficiency**: The entire system utilizes a very small fraction of the FPGA's available logic cells, demonstrating how a functional digital system can be miniaturized onto modern programmable logic.
- **Practical Focus**: The primary goal was a correct and understandable translation to HDL rather than performance optimization, maintaining the project's core educational value.

## Comparative Summary: Discrete vs. FPGA
This implementation highlights the practical differences between two hardware paradigms.

| Aspect | Discrete IC Implementation | FPGA Implementation |
| :--- | :--- | :--- |
| **Component Count** | 9 ICs, extensive wiring. | **1** primary chip. |
| **Design Method** | Wiring logic gates on a breadboard. | Writing and synthesizing HDL code. |
| **Flexibility** | Fixed; changes require physical rewiring. | **Reconfigurable** via code upload. |
| **Debugging** | Direct probing of every net with a multimeter. | Indirect, relying on synthesis reports and output observation. |
| **Core Experience** | Understanding gate-level data flow and propagation delay. | Learning the FPGA toolchain and HDL design patterns. |

## License
Licensed under the **Solderpad Hardware License v2.1**.  
See the [LICENSE](License) file for full terms.

## Contact
If you have any questions or suggestions, feel free to reach out:
- **GitHub:** [Neowizen](https://github.com/Yamil-Serrano)

