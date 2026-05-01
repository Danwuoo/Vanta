# Ablation Plan

## Purpose

Define staged ablations that test whether each Vanta runtime component contributes measurable value.

## Baseline

Traditional ReAct or function-calling agent with tool logs and final-answer judging.

## Ablation Stages

| Stage | Added Component | Main Question |
| --- | --- | --- |
| A | Execution IR and observation normalization | Does explicit action structure reduce invalid actions? |
| B | Evidence Packet and Verifier Runtime | Does structured evidence reduce false accepts? |
| C | Episode Journal and commit/abort semantics | Does governance improve audit and replay? |
| D | Failure Taxonomy and Targeted Recovery | Does targeted recovery beat blind retry under matched compute? |
| E | Context OS / working set compiler | Does context governance improve long-task stability? |

## Required Controls

- Same backbone model.
- Same task set.
- Same tool interface.
- Matched compute where possible.
- Fixed evaluation metrics before execution.

## Status

Not yet run.

## Related Documents

- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
- [Metrics Definition](../05_evaluation/Metrics_Definition.md)
