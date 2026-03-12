---
description: Run 4-tool lint pipeline (slang + verilator + svlint + verible) with unified report
allowed-tools: Bash, Read, Glob, Grep
argument-hint: <file.sv or filelist.f>
---

Run the full RTL lint pipeline on `$ARGUMENTS`.

Determine if the argument is a single .sv file or a filelist.f. Set up the target accordingly.

## Lint Pipeline

Run all 4 linters and collect results:

### 1. Slang (IEEE 1800-2023 compliance)
```bash
slang --lint-only $TARGET 2>&1
```

### 2. Verilator (synthesis lint)
```bash
verilator --lint-only -Wall --timing $TARGET 2>&1
```

### 3. svlint (style lint)
```bash
svlint $TARGET 2>&1
```

### 4. Verible (formatting/style)
```bash
verible-verilog-lint $TARGET 2>&1
```

## Output
Present a unified lint report:
1. Summary table: tool | errors | warnings
2. Deduplicated findings grouped by file and line
3. Severity classification (error/warning/info)
4. Suggested fixes for each finding

If all tools pass clean, confirm with a green summary.
