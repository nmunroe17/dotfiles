---
description: Generate module documentation from RTL (ports, params, FSM, wavedrom)
allowed-tools: Bash, Read, Glob, Grep, Write
argument-hint: <module_name or file.sv>
---

Generate comprehensive documentation for `$ARGUMENTS`.

## Documentation Sections

### 1. Module Overview
- Module name, file path, description (from header comments)
- Architecture summary

### 2. Parameters Table
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|

### 3. Port Table
| Port | Direction | Width | Clock Domain | Description |
|------|-----------|-------|-------------|-------------|

### 4. Functional Description
- State machine diagrams (if FSMs detected) in Mermaid format
- Data path description
- Key algorithms or transformations

### 5. Timing Diagrams
Generate WaveDrom JSON for key interface transactions:
```json
{signal: [
  {name: 'clk', wave: 'p........'},
  {name: 'data', wave: 'x.=.=.=.x', data: ['D0', 'D1', 'D2']}
]}
```

### 6. Integration Notes
- Clock and reset requirements
- Interface protocols
- Dependencies on other modules
- Known limitations

### 7. Output
Write documentation to `docs/<module_name>.md`.
