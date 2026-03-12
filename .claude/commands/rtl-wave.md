---
description: Parse VCD/FST waveform, summarize signal behavior and anomalies
allowed-tools: Bash, Read, Glob, Grep
argument-hint: <waveform.vcd or .fst>
---

Analyze waveform file `$ARGUMENTS`.

## Analysis Steps

### 1. Parse Waveform
Use pyvcd (for VCD) or fst2vcd + pyvcd for FST files.

### 2. Signal Summary
- List all signals with their widths and scopes
- Identify clock signals (periodic toggling)
- Identify reset signals
- Report simulation time range

### 3. Anomaly Detection
- Signals stuck at X or Z for extended periods
- Unexpected metastable values
- Clock glitches or irregular periods
- Reset sequences that look incomplete
- Signals that never toggle (dead logic indicators)

### 4. Key Transitions
- Report first N state changes for signals of interest
- Identify potential setup/hold violations (signal changes too close to clock edge)
- Flag any `$display`/`$error` markers in the dump

### 5. Output
Present findings as a structured report with signal names, timestamps, and observations.
