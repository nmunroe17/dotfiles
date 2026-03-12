---
description: SymbiYosys formal verification - auto-generate .sby if missing
allowed-tools: Bash, Read, Glob, Grep, Write
argument-hint: <module_name>
---

Run formal verification on module `$ARGUMENTS` using SymbiYosys.

## Flow

### 1. Check for existing .sby file
Look in `tb/formal/$ARGUMENTS.sby`. If not found, generate one:

```ini
[tasks]
bmc
prove

[options]
bmc: mode bmc
bmc: depth 20
prove: mode prove

[engines]
smtbmc z3

[script]
read_slang -top $ARGUMENTS filelist.f
prep -top $ARGUMENTS

[files]
filelist.f
```

### 2. Run SymbiYosys
```bash
cd tb/formal && sby -f $ARGUMENTS.sby 2>&1
```

### 3. Report
- Pass/fail for each task (BMC, prove)
- If failed: show the counterexample trace
- If passed: show depth reached and time taken
- List all assertions and cover points checked
- Suggest additional properties if coverage seems thin
