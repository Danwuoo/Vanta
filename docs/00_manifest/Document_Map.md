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
7. [Stage 1 Experiment 004 Closure](Stage_1_Experiment_004_Closure.md)
8. [Phase 5 Working Set Compiler Gate](Phase_5_Working_Set_Compiler_Gate.md)
9. [Stage 1 Experiment 005 Closure](Stage_1_Experiment_005_Closure.md)
10. [Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md)
11. [Post-Stage-1 Gate Inventory](Post_Stage_1_Gate_Inventory.md)
12. [Post-Stage-1 Larger Sample Plan](../04_experiments/Post_Stage_1_Larger_Sample_Plan.md)
13. [Baseline Identity Plan](../04_experiments/Baseline_Identity_Plan.md)
14. [Post-Stage-1 Metric Policy](../05_evaluation/Post_Stage_1_Metric_Policy.md)
15. [Design Theory](../01_theory/Design_Theory.md)
16. [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
17. [Research Hypotheses](../01_theory/Research_Hypotheses.md)
18. [Minimal Closed Loop Runtime Spec](../02_specs/Minimal_Closed_Loop_Runtime_Spec.md)
19. [Context OS and Working Set Compiler Note](../02_specs/Context_OS_and_Working_Set_Compiler_Note.md)
20. [Metrics Definition](../05_evaluation/Metrics_Definition.md)
21. [Ablation Plan](../04_experiments/Ablation_Plan.md)
22. [Experiment 004 Targeted Recovery](../04_experiments/Experiment_004_Targeted_Recovery.md)
23. [Experiment 005 Working Set Compiler](../04_experiments/Experiment_005_Working_Set_Compiler.md)
24. [MVP Architecture](../06_engineering/MVP_Architecture.md)

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

[Stage 1 Experiment 004 Closure](Stage_1_Experiment_004_Closure.md) closes the
Phase 4 targeted recovery local smoke after the measured Experiment 004 run at
`20260506_231941`. It records matched-compute recovery results on three
controlled Document Ops recovery fixtures, but it does not claim broad
validation of H4.

## Phase 5 Gate

[Phase 5 Working Set Compiler Gate](Phase_5_Working_Set_Compiler_Gate.md)
defines the local smoke gate for `Working Set Compiler v0`. It limits Phase 5
to reference-backed working-set artifacts and a bounded raw-trace comparison on
Document Ops long-context fixtures. It does not authorize full Context OS,
memory writes, learned retrieval, or validation claims for H3.

[Stage 1 Experiment 005 Closure](Stage_1_Experiment_005_Closure.md) closes the
Phase 5 working-set compiler local smoke after the measured Experiment 005 run
at `20260507_105950`. It records schema-valid, budget-adherent,
provenance-complete treatment working sets on five controlled Document Ops
long-context fixtures, but it does not claim broad validation of H3 or full
Context OS.

## Post-Stage-1 Gate

[Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md) controls
what can happen after all five local smoke closures. It defines separate
conditions for larger controlled samples, human or secondary labeling, and
broader runtime scope, while keeping full Context OS, memory writes,
irreversible effects, and production deployment out of scope until separate
gates exist.

[Post-Stage-1 Gate Inventory](Post_Stage_1_Gate_Inventory.md) is the tracking
index for `PS1-G1` through `PS1-G8`. It records artifact status, proposed
artifact paths, dependencies, and routing, but it does not replace the
advancement gate or satisfy any required artifact by itself.

[Post-Stage-1 Larger Sample Plan](../04_experiments/Post_Stage_1_Larger_Sample_Plan.md)
is the accepted `PS1-G1` sample-frame artifact. It fixes a 48-fixture Document
Ops sample frame and strata for Lane A planning, but it does not set acceptance
thresholds or report results.

[Baseline Identity Plan](../04_experiments/Baseline_Identity_Plan.md) is the
accepted `PS1-G5` baseline-identity artifact. It keeps OpenClaw results labeled
as local harness runs and supplements them with separately named direct API
arms when available.

[Post-Stage-1 Metric Policy](../05_evaluation/Post_Stage_1_Metric_Policy.md)
is the accepted `PS1-G2` metric-policy artifact. It fixes conservative
thresholds, no-regression checks, hard gates, and report labels for the first
48-fixture Lane A larger controlled sample.

## Translation Sources

- `docs/01_theory/設計構想與理論.md` -> [Design Theory](../01_theory/Design_Theory.md)
- `docs/01_theory/研讀驗證與反駁報告.md` -> [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
