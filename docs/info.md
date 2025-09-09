
# AXI4-Lite Top Project

## Overview
This project implements a **top-level AXI4-Lite system** with a master and a slave.  
It provides a **simple interface** for performing memory-mapped read and write operations without directly controlling AXI signals.

---

## How It Works
- The **top module** instantiates:
  - An **AXI4-Lite Master**  
  - An **AXI4-Lite Slave**  
- User interface signals:
  - `ui_in[0]` → Start Write  
  - `ui_in[2:1]` → Write Address  
  - `uio_in` → Write Data  
  - `ui_in[4]` → Start Read  
  - `ui_in[3:2]` → Read Address  
- Operation:
  - Master drives AXI4-Lite signals automatically.  
  - Slave responds according to protocol.  
  - `uo_out[0]` signals transaction completion.  
  - Read data appears on `uio_out`.

---

## How to Test
- Use the provided **Verilog testbench** (`tb.v`) to run a reset → write → read → check sequence.  
- Run with Icarus Verilog:
```bash
iverilog -o sim.vvp tt_um_axi4lite_top.v axi4lite_master.v axi4lite_slave.v tb.v
vvp sim.vvp
