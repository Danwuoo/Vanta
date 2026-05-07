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

Local smoke evidence now exists for stages A, B, C, and D, but the full
statistically powered ablation has not been run.

| Stage | Status | Interpretation |
| --- | --- | --- |
| A | Local smoke evidence | Experiment 001 closed the seven-fixture minimal loop smoke; this is not a complete compute-matched ablation. |
| B | Local smoke evidence | Experiment 002 closed the seven-fixture verifier hardening smoke; this is not broad validation of H2. |
| C | Local smoke evidence | Experiment 003 closed the seven-fixture journal/replay smoke; this is not broad validation of H5. |
| D | Local smoke evidence | Experiment 004 closed the three-fixture targeted recovery smoke under matched local compute; this is not broad validation of H4. |
| E | Planned | Experiment 005 limits Phase 5 to `Working Set Compiler v0` against bounded raw trace on five Document Ops long-context fixtures. |

## Stage D Compute-Matched Protocol

Stage D compares:

- `blind_retry_openclaw_agent_local/<model>_matched_budget`
- `targeted_recovery_openclaw_agent_local/<model>_matched_budget`

The matched compute budget is local and operational:

- Same OpenClaw model-call count.
- Same prompt character ceiling.
- Same response character ceiling.
- Same recovery action-attempt limit.

Treatment spends its budget on failure classification plus recovery proposal.
Blind retry spends the same budget without failure labels, credit vectors, or
recovery-policy hints. Token counts remain estimates unless the OpenClaw harness
exposes exact usage.

## Stage E Working-Set Protocol

Stage E compares:

- `raw_trace_bounded_openclaw_agent_local/<model>_matched_budget`
- `working_set_compiler_v0_reference_backed_openclaw_agent_local/<model>_matched_budget`

The matched budget is local and operational:

- Same OpenClaw model.
- Same prompt character ceiling.
- Same response character ceiling.
- Same embedded-context-only tool policy.

Treatment produces schema-valid `WorkingSet` artifacts. Baseline produces a
bounded raw-trace artifact. Neither arm may write memory or use full memory/raw
tool log dumps as a working set.

## Related Documents

- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
- [Metrics Definition](../05_evaluation/Metrics_Definition.md)
- [Stage 1 Experiment 001 Closure](../00_manifest/Stage_1_Experiment_001_Closure.md)
- [Stage 1 Experiment 002 Closure](../00_manifest/Stage_1_Experiment_002_Closure.md)
- [Stage 1 Experiment 003 Closure](../00_manifest/Stage_1_Experiment_003_Closure.md)
- [Stage 1 Experiment 004 Closure](../00_manifest/Stage_1_Experiment_004_Closure.md)
- [Experiment 004 Targeted Recovery](Experiment_004_Targeted_Recovery.md)
- [Experiment 004 Local Run Report](../05_evaluation/Experiment_004_Local_Run_Report.md)
- [Phase 5 Working Set Compiler Gate](../00_manifest/Phase_5_Working_Set_Compiler_Gate.md)
- [Experiment 005 Working Set Compiler](Experiment_005_Working_Set_Compiler.md)
