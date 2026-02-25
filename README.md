# DRFC MATLAB Reproduction Framework

This repository now includes a MATLAB framework to reproduce the algorithmic flow of:

**Transmit Waveform Design for Dual-Function Radar-Communication Systems via Hybrid Linear-Nonlinear Precoding**.

It focuses on a runnable and extensible **EFPP-SCA** structure (penalized feasibility + sequential convex approximation style updates), not exact paper-level numerics.

## Structure

```text
/matlab
  main_run.m
  config/default_config.m
  utils/
  models/
  algorithms/
  metrics/
  tests/smoke_test.m
  results/
```

## Run

```matlab
cd matlab
main_run
```

Outputs are written to:

- `matlab/results/objective_vs_iter.png`
- `matlab/results/violation_vs_iter.png`
- `matlab/results/radar_similarity_vs_iter.png`
- `matlab/results/rate_vs_iter.png`
- `matlab/results/run_output.mat`

## Smoke test

```matlab
cd matlab/tests
smoke_test
```

## CVX support

- The solver auto-detects CVX via `exist('cvx_begin','file')`.
- If CVX is unavailable, it automatically falls back to a projected-gradient SCA step.
- To use CVX, install it from the official CVX distribution and run `cvx_setup` in MATLAB.

## Notes

- MATLAB R2020+ compatible style.
- Constraints currently implemented: total transmit power and constant/near-constant modulus projection, with optional per-antenna power cap.
- Metrics include sum-rate (MU-MISO approximation), radar similarity, and aggregated constraint violation.
