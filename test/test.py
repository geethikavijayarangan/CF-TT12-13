# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 20 ns (50 MHz from your info.yaml)
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # ---------------- WRITE ----------------
    addr = 2
    wdata = 0x3C
    dut._log.info(f"WRITE: Addr={addr} Data=0x{wdata:02X}")

    dut.ui_in.value = (addr << 1) | 0b1   # start_write=1, addr on ui[2:1]
    dut.uio_in.value = wdata
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = (addr << 1)         # deassert start_write
    await ClockCycles(dut.clk, 5)         # wait some cycles for write

    # ---------------- READ ----------------
    dut._log.info(f"READ: Addr={addr}")
    dut.ui_in.value = (addr << 4) | (1 << 3)   # start_read=1, addr on ui[5:4]
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = (addr << 4)              # deassert start_read
    await ClockCycles(dut.clk, 5)              # wait some cycles for read

    read_data = int(dut.uo_out.value)
    dut._log.info(f"READ returned: 0x{read_data:02X}")

    # ---------------- CHECK ----------------
    assert read_data == wdata, f"TEST FAILED ❌ Expected 0x{wdata:02X}, Got 0x{read_data:02X}"
    dut._log.info("TEST PASSED ✅")
