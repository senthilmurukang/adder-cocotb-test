import os
import random
import sys
from pathlib import Path

import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.clock import Clock
import random

@cocotb.test()
async def test_clock_divider(dut):
    """Test ClockDivider VHDL module."""

    # Generate a clock signal
    clock = Clock(dut.clk, 10, units="ns")  # 10ns period (100MHz)
    cocotb.start_soon(clock.start())
    
    # Reset sequence
    dut.rst.value = 1
    await Timer(20, units="ns")
    dut.rst.value = 0
    await Timer(20, units="ns")
    
    # Set input values
    high_count = 5
    low_count = 5
    delay_count = 1
    
    dut.highCount.value = high_count
    dut.lowCount.value = low_count
    dut.delayCount.value = delay_count
    
    # Wait for reset propagation
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)
    
    # Monitor output
    prev_divClk = dut.divClk.value.integer
    
    for _ in range(50):  # Run for several cycles
        await RisingEdge(dut.clk)
        current_divClk = dut.divClk.value.integer
        if current_divClk != prev_divClk:
            cocotb.log.info(f"divClk changed: {prev_divClk} -> {current_divClk}")
        prev_divClk = current_divClk
    
    cocotb.log.info("Test completed.")
