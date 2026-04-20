# UVM Verification Project (SPI, RAM & System Integration)

## Overview
This project focuses on building a **modular UVM (Universal Verification Methodology) environment** to verify individual components and a complete integrated system. It is divided into three phases, emphasizing **verification reuse, scalability, and full coverage closure**.

---

## Project Structure

### Part 1: SPI Slave Verification
- Full UVM environment for SPI Slave  
- Includes:
  - Sequences (reset, main)
  - Constraints on protocol behavior (SS_n, MOSI, commands)
  - Functional coverage (command decoding, transitions, timing)
  - Assertions for:
    - Reset behavior
    - Command timing
    - FSM transitions  

---

### Part 2: Single-Port RAM Verification
- UVM environment for RAM
- Includes:
  - Sequences:
    - Reset
    - Write-only
    - Read-only
    - Mixed read/write
  - Constraints enforcing valid operation ordering  
  - Functional coverage:
    - Transaction types and ordering
    - Cross coverage with control signals  
  - Assertions for:
    - Reset correctness
    - Read/Write protocol correctness
    - Valid data signaling  

---

### Part 3: SPI Wrapper Verification (Integration)
- End-to-end system verification  
- Reuses:
  - SPI Slave UVM environment  
  - RAM UVM environment  
- Uses **passive agents** for integration  

#### Features:
- Combined protocol and memory verification  
- System-level constraints and sequences  
- Assertions for:
  - Reset behavior
  - MISO stability  
- Binding assertions across all modules  

---

## UVM Testbench Architecture

- **Agents** (Active/Passive)
- **Driver & Sequencer**
- **Monitor**
- **Scoreboard**
- **Reference (Golden) Model** *(implemented in Verilog)*
- **Functional Coverage Models**

---

## Sequences

Across all parts:
- `reset_sequence`
- `write_only_sequence`
- `read_only_sequence`
- `write_read_sequence`
- `main_sequence` (SPI-specific)

---

## Functional Coverage

- Command decoding (MOSI patterns)  
- Protocol timing (SS_n duration patterns)  
- Transaction ordering and dependencies  
- Cross coverage between control and data signals  

---

## Assertions

- Reset behavior (outputs cleared)  
- Protocol timing correctness  
- FSM state transitions  
- Read/Write sequencing rules  
- Output validity signaling  
