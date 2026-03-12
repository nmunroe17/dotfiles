---
description: Smart simulation - auto-detect cocotb vs verilator standalone, run, and report
allowed-tools: Bash, Read, Glob, Grep
argument-hint: <module_name>
---

Run simulation for module `$ARGUMENTS`.

## Auto-Detection Strategy

1. Check for `tb/cocotb/tests/test_$ARGUMENTS.py` — cocotb flow
2. Check for `tb/sv/tb_$ARGUMENTS.sv` — verilator SV testbench flow
3. If neither found, offer to generate a basic testbench

## Cocotb Flow
```bash
make sim-cocotb MODULE=$ARGUMENTS
```

## Verilator Standalone Flow
```bash
make sim MODULE=$ARGUMENTS
```

## Post-Simulation
1. Report pass/fail status
2. If VCD/FST generated, note the waveform file location
3. Summarize any assertion failures or `$error` messages
4. Report simulation time and performance
