# Failure Labeling Guide

## Purpose

Define initial labels for runtime failure analysis and targeted recovery experiments.

## Labels

| Code | Label | Description |
| --- | --- | --- |
| `F_REP` | Representation Failure | State representation is wrong, missing, fragmented, or inconsistent. |
| `F_PROC` | Procedural Failure | Procedure, plan, or action schema is wrong. |
| `F_SEARCH` | Search / Budget Failure | Branching, resource allocation, stopping, or exploration strategy is wrong. |
| `F_MEM` | Memory Failure | Memory read, omission, write, pollution, or staleness causes failure. |
| `F_ABS` | Abstraction Failure | Compression, abstraction granularity, or macro use causes failure. |
| `F_EVAL` | Evaluation Failure | Verifier, confidence, calibration, or risk judgment is wrong. |
| `F_EXEC` | Execution Governance Failure | Side effect, commit, rollback, replay, or tool provenance governance fails. |

## Labeling Rules

- Use multi-label attribution when multiple causes materially contributed.
- Prefer direct evidence over narrative plausibility.
- Mark `unknown` when logs are insufficient.
- Record whether the proposed recovery targeted the labeled failure class.

## Open Questions

- Should credit vectors be normalized probabilities?
- What minimum evidence is required to label `F_EXEC`?
