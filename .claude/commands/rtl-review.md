---
description: Deep RTL code review for synthesis, CDC, timing, coding style, and AMS quality
allowed-tools: Bash, Read, Glob, Grep
argument-hint: <file.sv or directory>
---

Perform a thorough RTL code review of `$ARGUMENTS`.

## Review Checklist

### 1. Synthesis Quality
- Inferred latches (incomplete if/case)
- Combinational loops
- Multi-driven nets
- Proper use of `always_ff`, `always_comb`, `always_latch`
- No `initial` blocks in synthesizable code
- Proper parameterization

### 2. Clock Domain Crossing (CDC)
- Signals crossing clock domains without synchronizers
- Multi-bit CDC without gray coding or handshake
- Async reset synchronization
- FIFO CDC patterns

### 3. Timing & Reset
- Reset strategy consistency (sync vs async)
- Async reset assertion, sync de-assertion pattern
- Clock gating correctness
- Critical path concerns (deep logic chains)

### 4. Coding Style
- Consistent naming: `snake_case` for signals, `UPPER_CASE` for parameters
- Module port ordering: clk, rst, inputs, outputs
- Proper use of `logic` vs `wire`/`reg`
- SystemVerilog type safety (enums, structs, packages)

### 5. AMS/Mixed-Signal (if applicable)
- `ams_*` prefix on behavioral models
- `real` signal discipline for analog quantities
- Parameter ranges and defaults for model tuning
- Proper sampling/quantization in ADC/DAC models

### 6. Verification Hooks
- Assertion coverage for key properties
- Functional coverage points
- `$display`/`$error` for debug (gated by verbosity)

## Output Format
Rate each finding as:
- **P0 (Critical):** Will cause silicon bug or synthesis failure
- **P1 (Major):** Likely functional issue or severe style violation
- **P2 (Moderate):** Potential issue or significant style concern
- **P3 (Minor):** Style improvement or best practice suggestion
- **P4 (Info):** Note for awareness, no action required

Read the file(s), analyze thoroughly, and present findings in a structured table.