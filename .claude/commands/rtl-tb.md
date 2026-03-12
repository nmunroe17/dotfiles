---
description: Generate cocotb 2.0 testbench from existing module ports
allowed-tools: Bash, Read, Glob, Grep, Write
argument-hint: <module_name or file.sv>
---

Generate a cocotb testbench for `$ARGUMENTS`.

## Steps

### 1. Parse Module Interface
Read the RTL source and extract:
- Module name
- Parameters with defaults
- Port list (direction, type, width, name)
- Clock and reset signals (by naming convention: `clk*`, `rst*`, `reset*`)

### 2. Generate Testbench: `tb/cocotb/tests/test_<module>.py`

Include:
- Clock generation for all clock ports
- Reset sequence utility function
- Basic reset test
- Randomized stimulus test skeleton
- Bus functional model helpers for standard interfaces (AXI, APB) if detected
- Proper cocotb 2.0 patterns: `cocotb.start_soon()`, `async/await`

### 3. Generate Makefile Fragment: `tb/cocotb/Makefile.<module>`

```makefile
TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell cat ../../filelist.f | grep -v '^//' | tr '\n' ' ')
TOPLEVEL = <module>
MODULE = test_<module>
include $(shell cocotb-config --makefiles)/Makefile.sim
```

### 4. Verify
Run a quick syntax check on the generated Python.
