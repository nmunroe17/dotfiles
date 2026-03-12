---
description: Analyze verification coverage gaps and suggest targeted tests
allowed-tools: Bash, Read, Glob, Grep, Write
argument-hint: <module_name>
---

Analyze verification coverage for `$ARGUMENTS`.

## Analysis Steps

### 1. Gather Existing Coverage
Check for Verilator coverage data:
```bash
verilator_coverage --annotate sim/coverage/ sim/coverage.dat 2>&1
```

Read coverage annotations and existing test files.

### 2. Code Coverage Analysis
- **Line coverage:** Identify unexecuted lines
- **Branch coverage:** Identify untaken branches (if/else, case arms)
- **Toggle coverage:** Identify signals that never toggle
- **FSM coverage:** Identify unreached states and untaken transitions

### 3. Functional Coverage Assessment
Review existing cocotb tests and SVA cover points:
- Which scenarios are tested?
- Which boundary conditions are exercised?
- Which error paths are covered?
- Which parameter combinations are tested?

### 4. Gap Analysis
Produce a prioritized list of coverage gaps:
- **Critical gaps:** Core functionality not exercised
- **Important gaps:** Error handling, boundary conditions
- **Nice-to-have:** Corner cases, rare scenarios

### 5. Test Suggestions
For each gap, suggest a specific test:
- Test name and description
- Stimulus sequence
- Expected behavior
- Which coverage points it would hit

### 6. Output
Write coverage report to `sim/coverage_report_<module>.md` and optionally generate test skeletons.
