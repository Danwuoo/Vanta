# Document Map

## Purpose

Map how documents relate so readers can navigate from theory to implementation without treating conceptual material as executable specification.

## Reading Order

1. [Project Manifest](Project_Manifest.md)
2. [Stage 0 Boundary Lock](Stage_0_Boundary_Lock.md)
3. [Stage 1 MVP Entry Gate](Stage_1_MVP_Entry_Gate.md)
4. [Stage 1 Experiment 001 Closure](Stage_1_Experiment_001_Closure.md)
5. [Stage 1 Experiment 002 Closure](Stage_1_Experiment_002_Closure.md)
6. [Stage 1 Experiment 003 Closure](Stage_1_Experiment_003_Closure.md)
7. [Design Theory](../01_theory/Design_Theory.md)
8. [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
9. [Research Hypotheses](../01_theory/Research_Hypotheses.md)
10. [Minimal Closed Loop Runtime Spec](../02_specs/Minimal_Closed_Loop_Runtime_Spec.md)
11. [Context OS and Working Set Compiler Note](../02_specs/Context_OS_and_Working_Set_Compiler_Note.md)
12. [Metrics Definition](../05_evaluation/Metrics_Definition.md)
13. [Ablation Plan](../04_experiments/Ablation_Plan.md)
14. [MVP Architecture](../06_engineering/MVP_Architecture.md)

## Layer Responsibilities

- Manifest documents define governance, traceability, and locked conceptual boundaries.
- Theory documents preserve conceptual sources and research pressure tests.
- Specs convert concepts into implementable MVP behavior.
- Schemas define portable data shapes.
- Experiments define how claims will be tested.
- Evaluation documents define metrics and labeling rules.
- Engineering documents define build sequencing and module boundaries.

## Stage 0 Gate

[Stage 0 Boundary Lock](Stage_0_Boundary_Lock.md) is the routing source for
conceptual boundary decisions before Stage 1 implementation. It does not validate
the architecture and does not replace downstream specs, schemas, experiments, or
evaluation documents.

## Stage 1 Gate

[Stage 1 MVP Entry Gate](Stage_1_MVP_Entry_Gate.md) locks Document Ops as the
first controlled MVP environment, limits allowed side-effect classes, and defines
the minimum commit rule for Phase 1 runtime implementation.

[Stage 1 Experiment 001 Closure](Stage_1_Experiment_001_Closure.md) closes the
Stage 1 local smoke phase after the measured Experiment 001 run. It records the
local smoke result and deferred work, but it does not claim statistical support
for H1 or promote the OpenClaw harness run to a pure model-only baseline.

[Stage 1 Experiment 002 Closure](Stage_1_Experiment_002_Closure.md) closes the
Phase 2 verifier hardening local smoke after the measured Experiment 002 run at
`20260504_205316`. It records a rules-first structured verifier correction, but
it does not claim broad validation of H2.

[Stage 1 Experiment 003 Closure](Stage_1_Experiment_003_Closure.md) closes the
Phase 3 journal audit and replay local smoke after the measured Experiment 003
run at `20260504_215304`. It records audit-complete, replay-consistent treatment
results on seven Document Ops fixtures, but it does not claim broad validation
of H5.

## Translation Sources

- `docs/01_theory/設計構想與理論.md` -> [Design Theory](../01_theory/Design_Theory.md)
- `docs/01_theory/研讀驗證與反駁報告.md` -> [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
