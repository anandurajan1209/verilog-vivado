# 16-bit Arithmetic Hardware Modules (Verilog)

A collection of synthesizable 16-bit Verilog HDL modules implementing different adder, multiplier, and comparator architectures. Each design explores a distinct hardware approach to the same arithmetic operation, useful for comparing performance, area, and delay trade-offs in digital design and FPGA implementation.

## Repository Structure

| File | Description |
|---|---|
| `16bit_ARRAY_multiplier.v` | 16-bit array multiplier — a straightforward, regular structure built from AND gates and adders arranged in a grid. |
| `16bit_BOOTH_multiplier.v` | 16-bit Booth multiplier — reduces the number of partial products using Booth's recoding algorithm, efficient for signed multiplication. |
| `16bit_CARRY_LOOK-AHEAD_adder.v` | 16-bit Carry Look-Ahead (CLA) adder — computes carries in advance using generate/propagate logic to reduce carry propagation delay. |
| `16bit_CARRY_SELECT_adder.v` | 16-bit Carry Select adder — precomputes sums for both possible carry-in values and selects the correct result, trading area for speed. |
| `16bit_DADDA_multiplier.v` | 16-bit Dadda multiplier — reduces partial products using a Dadda tree, minimizing the number of reduction stages. |
| `16bit_ITERATIVE_comparator.v` | 16-bit iterative comparator — compares operands bit by bit (or stage by stage) in a sequential/iterative fashion. |
| `16bit_KOGGE_STONE_adder.v` | 16-bit Kogge-Stone adder — a parallel prefix adder offering logarithmic-depth carry computation for high-speed addition. |
| `16bit_MAGNITUDE_comparator.v` | 16-bit magnitude comparator — determines whether one operand is greater than, less than, or equal to another. |
| `16bit_RIPPLE_CARRY_adder.v` | 16-bit Ripple Carry adder — the simplest adder design, chaining full adders with the carry rippling from LSB to MSB. |
| `16bit_SUBTRACTOR_comparator.v` | 16-bit subtractor-based comparator — performs comparison by subtraction and evaluating the sign/borrow result. |
| `16bit_TREE_comparator.v` | 16-bit tree comparator — compares operands using a tree-structured (divide-and-conquer) approach for reduced delay. |
| `adder_comparator_multiplier.docx` | Supporting documentation covering design details, theory, and/or simulation results for the modules above. |
| `README.md` | This file. |

## Overview

This repository is intended as a reference/learning set for exploring classic digital arithmetic circuit architectures at the RTL level in Verilog:

- **Adders:** Ripple Carry, Carry Look-Ahead, Carry Select, Kogge-Stone
- **Multipliers:** Array, Booth, Dadda
- **Comparators:** Magnitude, Iterative, Tree-based, Subtractor-based

Each module operates on 16-bit operands and can be simulated or synthesized independently.

## Getting Started

### Prerequisites
- A Verilog simulator (e.g., Icarus Verilog, ModelSim, Xilinx Vivado Simulator)
- (Optional) An FPGA toolchain such as Xilinx Vivado for synthesis and implementation

### Simulation
```bash
# Example using Icarus Verilog
iverilog -o sim_out 16bit_RIPPLE_CARRY_adder.v testbench.v
vvp sim_out
```
> Note: testbenches are not included in this repository yet — add your own or request them if needed.

### Synthesis
Each `.v` file can be added directly as a source module in your FPGA project (e.g., Xilinx Vivado) and instantiated as needed.

## Design Comparison

| Category | Module | Key Trade-off |
|---|---|---|
| Adder | Ripple Carry | Simple, low area, but slow (linear carry delay) |
| Adder | Carry Look-Ahead | Faster carry computation, more area |
| Adder | Carry Select | Speed via redundant computation, higher area |
| Adder | Kogge-Stone | Fastest (logarithmic delay), highest area/routing complexity |
| Multiplier | Array | Simple, regular structure, higher latency |
| Multiplier | Booth | Fewer partial products, efficient for signed numbers |
| Multiplier | Dadda | Fast partial product reduction, more complex wiring |
| Comparator | Magnitude | Direct bit-wise comparison logic |
| Comparator | Iterative | Sequential comparison, lower resource usage |
| Comparator | Tree | Parallel/hierarchical comparison, lower delay |
| Comparator | Subtractor-based | Reuses subtractor logic for comparison |

## Future Work
- Add self-checking testbenches for each module
- Add timing/area synthesis reports (e.g., from Vivado)
- Add a top-level wrapper for selecting between architectures at instantiation

## License
Specify a license (e.g., MIT) here if you'd like this repository to be open source.

## Author
Maintained as part of ongoing digital design / FPGA coursework and project work.
