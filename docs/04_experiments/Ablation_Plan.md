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

Local smoke evidence now exists for stages A, B, and C, but the full
compute-matched ablation has not been run.

| Stage | Status | Interpretation |
| --- | --- | --- |
| A | Local smoke evidence | Experiment 001 closed the seven-fixture minimal loop smoke; this is not a complete compute-matched ablation. |
| B | Local smoke evidence | Experiment 002 closed the seven-fixture verifier hardening smoke; this is not broad validation of H2. |
| C | Local smoke evidence | Experiment 003 closed the seven-fixture journal/replay smoke; this is not broad validation of H5. |
| D | Not yet run | Targeted Recovery requires expanded failure fixtures before compute-matched comparison with blind retry. |
| E | Not yet run | Context OS / working set compiler remains deferred until earlier phases produce broader logs and metrics. |

## Related Documents

- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
- [Metrics Definition](../05_evaluation/Metrics_Definition.md)
- [Stage 1 Experiment 001 Closure](../00_manifest/Stage_1_Experiment_001_Closure.md)
- [Stage 1 Experiment 002 Closure](../00_manifest/Stage_1_Experiment_002_Closure.md)
- [Stage 1 Experiment 003 Closure](../00_manifest/Stage_1_Experiment_003_Closure.md)
