---
description: Clock domain crossing analysis - detect crossings and check synchronizers
allowed-tools: Bash, Read, Glob, Grep
argument-hint: <file.sv or directory>
---

Perform CDC (Clock Domain Crossing) analysis on `$ARGUMENTS`.

## Analysis Steps

### 1. Identify Clock Domains
- Find all `always_ff @(posedge <clk>)` blocks
- Map each signal to its clock domain
- Identify asynchronous resets

### 2. Detect Domain Crossings
For each signal used in a different clock domain than where it's assigned:
- Single-bit crossings — check for 2FF synchronizer
- Multi-bit crossings — check for gray code or handshake protocol
- Control signals — check for pulse synchronizer if needed
- Bus crossings — check for async FIFO or handshake

### 3. Synchronizer Audit
Verify synchronizer patterns:
- **2FF sync:** Two back-to-back flip-flops, no logic between
- **Gray code:** Proper binary-to-gray and gray-to-binary conversion
- **Handshake:** REQ/ACK protocol with proper synchronization on both sides
- **Async FIFO:** Gray-coded pointers, proper empty/full generation

### 4. Risk Assessment
Rate each crossing:
- **SAFE:** Properly synchronized
- **WARNING:** Synchronizer present but pattern is unusual
- **DANGER:** No synchronizer detected
- **CRITICAL:** Multi-bit crossing without encoding/handshake

### 5. Report
Table format: source_signal | source_clk | dest_clk | crossing_type | sync_method | status
