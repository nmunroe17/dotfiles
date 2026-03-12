---
description: Yosys synthesis with slang plugin, area/cell report
allowed-tools: Bash, Read, Glob, Grep, Write
argument-hint: <module_name>
---

Synthesize module `$ARGUMENTS` using Yosys with the slang frontend.

## Synthesis Flow

### 1. Generate synthesis script (if not in synth/)
Create a Yosys TCL script:
```tcl
read_slang -top $ARGUMENTS filelist.f
synth -top $ARGUMENTS
abc -g AND,OR,XOR,MUX,AOI,OAI
stat
write_verilog synth/${ARGUMENTS}_synth.v
```

### 2. Run Yosys
```bash
yosys -s synth/${ARGUMENTS}.ys 2>&1 | tee synth/${ARGUMENTS}_synth.log
```

### 3. Report
- Cell count breakdown by type
- Area estimate (generic gates)
- Critical path info if available
- Warnings about unmapped or problematic constructs
- Comparison with previous synthesis if log exists
