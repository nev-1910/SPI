import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer


@cocotb.test()
async def test_spi_master(dut):

    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.rst_n.value = 0
    dut.ena.value = 1

    dut.ui_in.value = 0b10110011
    dut.uio_in.value = 0

    await Timer(20, unit="ns")

    dut.rst_n.value = 1

    await Timer(20, unit="ns")

    dut.uio_in.value = 1

    await Timer(20, unit="ns")

    dut.uio_in.value = 0

    await Timer(500, unit="ns")
