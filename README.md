# 4-Bit Minimalist ALU

A **hardware-minimalist 4-bit Arithmetic Logic Unit** built with discrete logic gates, implementing only three fundamental operations to demonstrate **NAND-universality** principles. This ALU showcases how complex computations can be built from simple components, following the philosophy of hardware/software trade-offs in computer architecture.

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
<img width="1269" height="831" alt="Circuit Schematic" src="https://github.com/user-attachments/assets/e758af1f-6e84-41a4-8573-ca7d8a015c2d" />
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
