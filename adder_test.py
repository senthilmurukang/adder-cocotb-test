import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.result import TestFailure
from cocotb.regression import TestFactory

@cocotb.coroutine
def reset_dut(dut, duration):
    dut.reset_n <= 0
    yield cocotb.triggers.Timer(duration)
    dut.reset_n <= 1
    yield cocotb.triggers.Timer(duration)

@cocotb.coroutine
def adder_test(dut):
    A = 0b1010
    B = 0b0110
    expected_sum = 0b10000

    dut.A <= A
    dut.B <= B

    yield RisingEdge(dut.clk)

    if dut.sum != expected_sum:
        raise TestFailure("Incorrect sum. Expected {}, got {}".format(bin(expected_sum), bin(dut.sum)))

@cocotb.test()
def adder_testbench(dut):
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.fork(clock.start())

    yield reset_dut(dut, 20)
    yield adder_test(dut)

# Running the testbench
factory = TestFactory(test_function=adder_testbench)
factory.generate_tests()
