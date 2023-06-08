SIM := /usr/local/bin/verilator

TOPLEVEL_LANG := verilog

PWD=$(shell pwd)

export PYTHONPATH := $(PWD)/../model:$(PYTHONPATH)

VERILOG_SOURCES = $(PWD)/../hdl/adder.sv

TOPLEVEL := adder
MODULE   := test_adder

include $(shell cocotb-config --makefiles)/simulators/Makefile.verilator