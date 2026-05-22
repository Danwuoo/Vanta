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
12. [Obsidian Graph Status](Obsidian_Graph_Status.md)
13. [Post-Stage-1 Larger Sample Plan](../04_experiments/Post_Stage_1_Larger_Sample_Plan.md)
14. [Post-Stage-1 Larger Sample G6 Successor Plan](../04_experiments/Post_Stage_1_Larger_Sample_G6_Successor_Plan.md)
15. [Post-Stage-1 Lane A 20260519_232854 Run Report](../05_evaluation/Post_Stage_1_Lane_A_20260519_232854_Run_Report.md)
16. [Post-Stage-1 Lane A 20260519_232854 Closure Candidate](Post_Stage_1_Lane_A_20260519_232854_Closure_Candidate.md)
17. [Post-Stage-1 Lane A 20260522_012221 Run Report](../05_evaluation/Post_Stage_1_Lane_A_20260522_012221_Run_Report.md)
18. [Post-Stage-1 Lane A 20260522_012221 Closure Candidate](Post_Stage_1_Lane_A_20260522_012221_Closure_Candidate.md)
19. [Baseline Identity Plan](../04_experiments/Baseline_Identity_Plan.md)
20. [Post-Stage-1 Metric Policy](../05_evaluation/Post_Stage_1_Metric_Policy.md)
21. [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md)
22. [Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md)
23. [Context OS Expansion Gate](Context_OS_Expansion_Gate.md)
24. [Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md)
25. [Design Theory](../01_theory/Design_Theory.md)
26. [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
27. [Research Hypotheses](../01_theory/Research_Hypotheses.md)
28. [Minimal Closed Loop Runtime Spec](../02_specs/Minimal_Closed_Loop_Runtime_Spec.md)
29. [Context OS and Working Set Compiler Note](../02_specs/Context_OS_and_Working_Set_Compiler_Note.md)
30. [Metrics Definition](../05_evaluation/Metrics_Definition.md)
31. [Ablation Plan](../04_experiments/Ablation_Plan.md)
32. [Experiment 004 Targeted Recovery](../04_experiments/Experiment_004_Targeted_Recovery.md)
33. [Experiment 005 Working Set Compiler](../04_experiments/Experiment_005_Working_Set_Compiler.md)
34. [MVP Architecture](../06_engineering/MVP_Architecture.md)

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

[Post-Stage-1 Larger Sample G6 Successor Plan](../04_experiments/Post_Stage_1_Larger_Sample_G6_Successor_Plan.md)
is the `PS1-LA-SAMPLE-002` execution successor for G6-aware Lane A runs. It
keeps the 48-fixture, 8-stratum frame, fixes the structured-edit fixture
routing, and names the `Vanta.PostStage1LargerSample` runner artifact contract.
It does not report measured results or create closure acceptance.

[Post-Stage-1 Lane A 20260519_232854 Run Report](../05_evaluation/Post_Stage_1_Lane_A_20260519_232854_Run_Report.md)
records the first measured `PS1-LA-SAMPLE-002` run. The run completed and
produced `run.json`, `summary.md`, and `fixture_inventory.md`, but its threshold
status is `failed_no_acceptance` because required artifacts, replay consistency,
and audit completeness did not meet `PS1-LA-METRIC-001`.

[Post-Stage-1 Lane A 20260519_232854 Closure Candidate](Post_Stage_1_Lane_A_20260519_232854_Closure_Candidate.md)
is a non-accepting manifest review candidate for that measured run. It records
the blocking fix batches and explicitly does not create `accepted_by_closure`.

[Post-Stage-1 Lane A 20260522_012221 Run Report](../05_evaluation/Post_Stage_1_Lane_A_20260522_012221_Run_Report.md)
records the measured rerun after the first repair batch. The run completed and
produced the required result files, but its threshold status remains
`failed_no_acceptance` because task success, required artifacts, replay
consistency, and audit completeness did not meet `PS1-LA-METRIC-001`.

[Post-Stage-1 Lane A 20260522_012221 Closure Candidate](Post_Stage_1_Lane_A_20260522_012221_Closure_Candidate.md)
is a non-accepting manifest review candidate for the repair rerun. It records
the remaining planner-context, positive-fixture alignment, and negative-fixture
rejection-discipline fix batches.

[Baseline Identity Plan](../04_experiments/Baseline_Identity_Plan.md) is the
accepted `PS1-G5` baseline-identity artifact. It keeps OpenClaw results labeled
as local harness runs and supplements them with separately named direct API
arms when available.

[Post-Stage-1 Metric Policy](../05_evaluation/Post_Stage_1_Metric_Policy.md)
is the accepted `PS1-G2` metric-policy artifact. It fixes conservative
thresholds, no-regression checks, hard gates, and report labels for the first
48-fixture Lane A larger controlled sample.

[Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md)
is the accepted `PS1-G3` and `PS1-G4` labeling-policy artifact. It fixes the
evidence sufficiency scale, label scope matrix, double-review requirements, and
adjudication rules for Lane B human or secondary labeling.

[Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md)
is the accepted `PS1-G6` artifact and now records the local schema-backed
implementation of `Document Ops Structured Edit Action Surface v0`. The
implementation stays fixture-local, uses only `READ_ONLY`, `SIMULATED`, and
`REVERSIBLE`, and does not authorize full Context OS, side-effect escalation,
or validation claims.

[Context OS Expansion Gate](Context_OS_Expansion_Gate.md) is the accepted
`PS1-G7` gate-definition artifact. It unlocks Context OS specification and
evaluation planning only; full Context OS implementation, learned retrieval,
compression, memory governance, memory writes, and H3 validation remain blocked
until later accepted specs, schemas, experiments, labels, and implementation
batches exist.

[Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md) is the accepted
`PS1-G8` gate-definition artifact. It unlocks side-effect specification, schema
impact review, evaluation planning, and implementation planning only; runtime
execution of `COMMITTABLE`, `IRREVERSIBLE`, and `MEMORY_WRITE` actions remains
blocked until later accepted specs, schemas, experiments, labels, and
implementation batches exist.

## Obsidian Graph

[Obsidian Graph Status](Obsidian_Graph_Status.md) defines the current graph
filter, layer hub spine, post-Stage-1 workbench, and cleanup rules for the
Obsidian vault. It is navigation support only and does not replace the manifest,
document map, or traceability matrix.

## Translation Sources

- `docs/01_theory/設計構想與理論.md` -> [Design Theory](../01_theory/Design_Theory.md)
- `docs/01_theory/研讀驗證與反駁報告.md` -> [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
