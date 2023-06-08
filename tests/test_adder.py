import os
import random
import sys
from pathlib import Path

import cocotb
from cocotb.runner import get_runner
from cocotb.triggers import Timer

if cocotb.simulator.is_running():
    from adder_model import adder_model


@cocotb.test()
async def adder_basic_test(dut):
    """Test for 5 + 10"""

    A = 5
    B = 10

    dut.A.value = A
    dut.B.value = B

    await Timer(2, units="ns")

    assert dut.sum.value == adder_model(
        A, B
    ), f"Adder result is incorrect: {dut.sum.value} != 15"


@cocotb.test()
async def adder_randomised_test(dut):
    """Test for adding 2 random numbers multiple times"""

    for i in range(10):

        A = random.randint(0, 7)
        B = random.randint(0, 7)

        dut.A.value = A
        dut.B.value = B

        await Timer(2, units="ns")

        assert dut.sum.value == adder_model(
            A, B
        ), "Randomised test failed with: {A} + {B} = {sum}".format(
            A=dut.A.value, B=dut.B.value, sum=dut.sum.value
        )


def test_adder_runner():
    """Simulate the adder example using the Python runner.

    This file can be run directly or via pytest discovery.
    """
    sim = os.getenv("SIM", "icarus")

    proj_path = Path(__file__).resolve().parent.parent
    # equivalent to setting the PYTHONPATH environment variable
    sys.path.append(str(proj_path / "model"))

    verilog_sources = [proj_path / "hdl" / "adder.sv"]

    # equivalent to setting the PYTHONPATH environment variable
    sys.path.append(str(proj_path / "tests"))

    runner = get_runner(sim)
    runner.build(
        verilog_sources=verilog_sources,
        hdl_toplevel="adder",
        always=True,
    )
    runner.test(hdl_toplevel="adder", test_module="test_adder")


if __name__ == "__main__":
    test_adder_runner()
