---
description: Auto-fix lint errors (auto-fixable immediately, semi-auto with confirmation)
allowed-tools: Bash, Read, Glob, Grep, Edit
argument-hint: <file.sv or filelist.f>
---

Automatically fix lint issues in `$ARGUMENTS`.

## Flow

### 1. Run Lint Pipeline
Run slang, verilator, svlint, and verible on the target. Collect all errors and warnings.

### 2. Classify Fixes

**Auto-fix (apply immediately):**
- Missing `endmodule` labels — add `: module_name`
- Trailing whitespace — remove
- Missing `default` in case statements — add with `$error`
- Width mismatch in assignments — add explicit cast/resize
- `always @*` — `always_comb`
- `reg` — `logic` (when not in legacy code)

**Semi-auto (show diff, ask for confirmation):**
- Adding missing sensitivity list entries
- Splitting combined `always` blocks (mixed sequential/combinational)
- Adding reset values to flip-flops
- Restructuring if/case for latch prevention
- Changing port directions

**Manual (report only):**
- Architectural issues (combinational loops, multi-driven nets)
- CDC violations
- Functionality changes

### 3. Apply Fixes
For auto-fixes: apply directly using Edit tool.
For semi-auto: show the proposed change and ask for confirmation.
For manual: report with context and suggested approach.

### 4. Re-lint
Run the lint pipeline again to verify fixes and report remaining issues.
