---
description: Create RNM analog behavioral model (ADC, DAC, PLL, LDO, bandgap, comparator)
allowed-tools: Bash, Read, Glob, Grep, Write
argument-hint: "<model_type> <module_name> [options]"
---

Create a Real Number Modeling (RNM) analog behavioral model.

Parse `$ARGUMENTS`: first word is model type, second is module name.

## Supported Model Types

### ADC (Analog-to-Digital Converter)
Parameters: BITS, VREF, SAMPLE_RATE, INL_LSB, DNL_LSB, NOISE_SIGMA
- Sample-and-hold with configurable aperture
- Quantization with INL/DNL error injection
- Gaussian noise model
- Saturation/clipping behavior

### DAC (Digital-to-Analog Converter)
Parameters: BITS, VREF, SETTLING_TIME, INL_LSB, DNL_LSB, GLITCH_ENERGY
- Ideal conversion with error injection
- Settling time model (exponential)
- Glitch energy model on transitions

### PLL (Phase-Locked Loop)
Parameters: FREF, FOUT, LOCK_TIME, JITTER_RMS, PHASE_NOISE
- Behavioral lock acquisition
- Locked/unlocked state machine
- Output jitter model (random + deterministic)
- Lock detect output

### LDO (Low-Dropout Regulator)
Parameters: VOUT, DROPOUT, PSRR_DB, LOAD_REG, LINE_REG, NOISE_UV
- Output regulation with line/load effects
- PSRR frequency response (simplified)
- Dropout behavior
- Startup sequence

### Bandgap (Voltage Reference)
Parameters: VREF, TC_PPM, NOISE_UV, STARTUP_TIME
- Temperature-dependent output (parabolic)
- Startup ramp
- Noise injection

### Comparator
Parameters: VOS_MV, DELAY_NS, HYSTERESIS_MV, INPUT_RANGE
- Input offset voltage
- Propagation delay model
- Hysteresis
- Metastability window near threshold

## Output Files
1. `rtl/src/ams/ams_<module_name>.sv` — behavioral model
2. `tb/cocotb/tests/test_ams_<module_name>.py` — characterization testbench
3. Model documentation header with parameter descriptions

All models use the `ams_` prefix and `real` signals for analog quantities.
