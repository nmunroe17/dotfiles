---
description: Generate SVA assertions and cover points as a bind file
allowed-tools: Bash, Read, Glob, Grep, Write
argument-hint: <module_name or file.sv>
---

Generate SystemVerilog Assertions for `$ARGUMENTS`.

## Steps

### 1. Analyze Module
Read the RTL and identify:
- All flip-flop outputs (candidates for stability checks)
- FSM states and transitions
- Interface handshake signals
- Counter ranges and overflow conditions
- FIFO pointers and full/empty conditions
- AMS model parameters and valid ranges

### 2. Generate Assertions

**Protocol assertions:**
- Handshake protocols (valid/ready must follow rules)
- Request must eventually get response
- No data change while valid and not ready

**Safety assertions:**
- FSM no-illegal-state
- Counter no-overflow/underflow
- FIFO no-simultaneous-full-and-empty
- Reset must initialize all flops
- One-hot signals stay one-hot

**Liveness assertions:**
- FSM must eventually leave each state
- FIFO must eventually not be full
- Response within bounded cycles

**Cover points:**
- Each FSM state reached
- Each FSM transition exercised
- Boundary conditions (counter max, FIFO full/empty)
- All parameter combinations of interest

### 3. Output
Write to `tb/formal/<module_name>_props.sv` as a bind file:
```systemverilog
module <module_name>_props (
    // port mirrors
);
    // assertions here
endmodule

bind <module_name> <module_name>_props props_inst (.*);
```
