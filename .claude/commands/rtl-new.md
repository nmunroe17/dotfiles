---
description: Scaffold a new module with testbench, formal props, and filelist update
allowed-tools: Bash, Read, Glob, Grep, Write, Edit
argument-hint: "<module_name> <category: digital|ams|clk|top>"
---

Create a new RTL module scaffold for `$ARGUMENTS`.

Parse arguments: first word is module name, second is category (default: digital).

## Files to Create

### 1. RTL Source: `rtl/src/<category>/<module_name>.sv`
```systemverilog
module <module_name> #(
    parameter int WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out
);

    // TODO: Implement module logic
    assign data_out = data_in;

endmodule : <module_name>
```

### 2. Cocotb Test: `tb/cocotb/tests/test_<module_name>.py`
```python
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_reset(dut):
    """Test reset behavior."""
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

@cocotb.test()
async def test_basic(dut):
    """Basic functional test."""
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)
    # TODO: Add test stimulus
```

### 3. SVA Properties: `tb/formal/<module_name>_props.sv`
Bind file with basic assertions (reset check, output stability).

### 4. Formal Config: `tb/formal/<module_name>.sby`
SymbiYosys configuration for BMC + prove.

### 5. Update filelist.f
Append the new source file path.

After creation, run a quick `slang --lint-only` on the new module to verify syntax.
