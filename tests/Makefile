SIM := /usr/local/bin/verilator

TOPLEVEL_LANG := vhdl

PWD=$(shell pwd)

export PYTHONPATH := $(PWD)/../model:$(PYTHONPATH)

VHDL_SOURCES = $(PWD)/../hdl/adder.vhdl

TOPLEVEL := adder
MODULE   := test_adder

include $(shell cocotb-config --makefiles)/simulators/Makefile.verilator