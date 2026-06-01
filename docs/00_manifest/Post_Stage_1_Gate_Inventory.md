# Post-Stage-1 Gate Inventory

## Purpose

This document is the tracking index for post-Stage-1 gate items. It records the
artifact status, proposed artifact path, routing dependencies, and downstream
unlocks for `PS1-G0` through `PS1-G8`.

This inventory is not an acceptance policy, experiment plan, validation report,
or replacement for [Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md).
It does not accept gate artifacts and does not authorize larger samples, human
or secondary labels, runtime expansion, Context OS expansion, or side-effect
expansion.

## Scope

This inventory covers `PS1-G1` through `PS1-G8` as defined by
[Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md). It retains
`PS1-G0` only as a met prerequisite so readers can see the full post-smoke
routing path.

This document does not redefine the gate items. The normative source remains
[Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md) or a
successor manifest gate that explicitly supersedes it.

## Status Vocabulary

| Status | Meaning |
| --- | --- |
| `Open` | No required artifact exists yet. |
| `Drafting` | The required artifact is under development but has not been accepted by the gate. |
| `Ready for Review` | The artifact is formed, but routing, traceability, or export synchronization is incomplete. |
| `Accepted` | The required artifact exists and has been explicitly accepted by the manifest gate or successor gate. |
| `Superseded` | The item has been replaced by a later gate or document. |

## Gate Inventory Table

| Gate ID | Lane | Current status | Required artifact | Proposed artifact path | Upstream dependencies | Downstream unlocks | Must not claim |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `PS1-G0` | All lanes prerequisite | `Accepted` | Closure docs 001 through 005 and linked run reports | Existing closure docs and run reports | Stage 1 closure docs 001 through 005 | Post-Stage-1 planning can be routed through `PS1-G1` through `PS1-G8` | The five local smoke closures are not broad validation. |
| `PS1-G1` | Larger Controlled Samples | `Accepted` | [Post-Stage-1 Larger Sample Plan](../04_experiments/Post_Stage_1_Larger_Sample_Plan.md); G6-aware execution successor [Post-Stage-1 Larger Sample G6 Successor Plan](../04_experiments/Post_Stage_1_Larger_Sample_G6_Successor_Plan.md) | `docs/04_experiments/Post_Stage_1_Larger_Sample_Plan.md`; `docs/04_experiments/Post_Stage_1_Larger_Sample_G6_Successor_Plan.md` | `PS1-G0`; Document Ops benchmark; closure reports 001 through 005; `PS1-G6` local structured edit implementation | Larger controlled sample execution through `Vanta.PostStage1LargerSample`; input to `PS1-G2` | Acceptance claims require the accepted metric policy, measured results, and closure acceptance. |
| `PS1-G2` | Larger Controlled Samples | `Accepted` | [Post-Stage-1 Metric Policy](../05_evaluation/Post_Stage_1_Metric_Policy.md) | `docs/05_evaluation/Post_Stage_1_Metric_Policy.md` | `PS1-G1`; `PS1-G5`; metrics definition; closure reports 001 through 005 | Threshold-governed acceptance candidates for larger controlled samples | Passing thresholds is not broad validation and still requires measured run reports plus closure acceptance. |
| `PS1-G3` | Human or Secondary Labeling | `Accepted` | [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md) | `docs/05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md` | `PS1-G0`; Evidence Packet spec; Metrics Definition; labeling guides | Evidence sufficiency labeling can begin under the fixed `PS1-LB-LABEL-001` scale | Evidence sufficiency labels have not been collected; no broad label claim exists yet. |
| `PS1-G4` | Human or Secondary Labeling | `Accepted` | [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md) | `docs/05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md` | `PS1-G0`; `PS1-G3`; labeling guides | Broader subjective label claims can use the accepted review and adjudication policy after labels are collected; the active blinded packet is prepared at `docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/` | Subjective metrics cannot support broad claims without policy-compliant packets, review, and adjudication records. |
| `PS1-G5` | Larger Controlled Samples | `Accepted` | [Baseline Identity Plan](../04_experiments/Baseline_Identity_Plan.md) | `docs/04_experiments/Baseline_Identity_Plan.md` | `PS1-G0`; OpenClaw local harness closure notes; Experiment 001 baseline records | Baseline arm naming for larger controlled samples; input to `PS1-G2` | OpenClaw harness results are not promoted to pure model-only baseline results. |
| `PS1-G6` | Broader Runtime Scope | `Accepted` | [Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md) | `docs/00_manifest/Post_Stage_1_Runtime_Scope_Proposal.md` | `PS1-G0`; Stage 1 scope boundaries; Execution IR, Evidence Packet, Commit/Abort/Replay specs | Local schema-backed implementation of `Document Ops Structured Edit Action Surface v0` | Local implementation and tests do not validate H1-H5 or authorize broader side-effect classes. |
| `PS1-G7` | Broader Runtime Scope | `Accepted` | [Context OS Expansion Gate](Context_OS_Expansion_Gate.md); draft planning bundle [spec](../02_specs/Post_Stage_1_Context_OS_Planning_Draft_Spec.md), [schema impact review](../03_schemas/Post_Stage_1_Context_OS_Schema_Impact_Review.md), and [evaluation plan](../04_experiments/Post_Stage_1_Context_OS_Evaluation_Plan.md) | `docs/00_manifest/Context_OS_Expansion_Gate.md`; `docs/02_specs/Post_Stage_1_Context_OS_Planning_Draft_Spec.md`; `docs/03_schemas/Post_Stage_1_Context_OS_Schema_Impact_Review.md`; `docs/04_experiments/Post_Stage_1_Context_OS_Evaluation_Plan.md` | `PS1-G0`; Phase 5 gate; Experiment 005 closure; Working Set Compiler note; `PS1-G1` through `PS1-G5` policies; `20260601_113121` accepted Lane A closure run; active Lane B packet prepared but labels `Not yet run` | Context OS specification and evaluation planning only | Runtime implementation, schema changes, full Context OS validation, learned retrieval, compression, memory governance, and H3 validation are not authorized. |
| `PS1-G8` | Broader Runtime Scope | `Accepted` | [Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md) | `docs/00_manifest/Side_Effect_Escalation_Gate.md` | `PS1-G0`; Stage 1 side-effect allowances; Commit Abort Replay Semantics; Evidence Packet and Verifier Runtime | Side-effect specification, schema impact review, evaluation planning, and implementation planning | Runtime execution of `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` actions is not authorized; rollback must not be assumed. |

## Dependency Order

- `PS1-G1`, `PS1-G2`, and `PS1-G5` are accepted and provide the Lane A sample,
  metric, and baseline identity policies.
- `PS1-LA-SAMPLE-002` is the G6-aware Lane A execution successor. It preserves
  the accepted 48-fixture sample size and 8-stratum shape while fixing
  structured-edit routing and runner artifacts for
  `Vanta.PostStage1LargerSample`.
- The first measured `PS1-LA-SAMPLE-002` run at
  `docs/04_experiments/results/post_stage_1_larger_sample/20260519_232854/`
  completed with threshold status `failed_no_acceptance`. It produced the
  required run artifacts, but the
  [run report](../05_evaluation/Post_Stage_1_Lane_A_20260519_232854_Run_Report.md)
  and
  [closure candidate](Post_Stage_1_Lane_A_20260519_232854_Closure_Candidate.md)
  record required-artifact, replay, and audit blockers. It is not
  `accepted_by_closure`.
- A repair-batch rerun at
  `docs/04_experiments/results/post_stage_1_larger_sample/20260522_012221/`
  also completed with threshold status `failed_no_acceptance`. It preserved
  process-integrity hard gates and fixed the repeated-step audit-ref collapse,
  but the
  [run report](../05_evaluation/Post_Stage_1_Lane_A_20260522_012221_Run_Report.md)
  and
  [closure candidate](Post_Stage_1_Lane_A_20260522_012221_Closure_Candidate.md)
  record remaining task-success, required-artifact, replay, and audit blockers.
  It is not `accepted_by_closure`.
- A compact fixture-alignment rerun at
  `docs/04_experiments/results/post_stage_1_larger_sample/20260523_223106/`
  completed with threshold status `pass_acceptance_candidate`. The
  [run report](../05_evaluation/Post_Stage_1_Lane_A_20260523_223106_Run_Report.md)
  and
  [closure candidate](Post_Stage_1_Lane_A_20260523_223106_Closure_Candidate.md)
  record valid required artifacts, replay consistency `1.0`, audit completeness
  `1.0`, and treatment task success `0.9583`. It is still not
  `accepted_by_closure` and does not validate H1-H5.
- A structured negative rejection alignment rerun at
  `docs/04_experiments/results/post_stage_1_larger_sample/20260525_223239/`
  completed with threshold status `pass_acceptance_candidate`. The
  [run report](../05_evaluation/Post_Stage_1_Lane_A_20260525_223239_Run_Report.md)
  and
  [closure candidate](Post_Stage_1_Lane_A_20260525_223239_Closure_Candidate.md)
  record valid required artifacts, replay consistency `1.0`, audit completeness
  `1.0`, treatment task success `0.9792`, one measured root-planner overshoot on
  `docops_ws_evidence_packet_001`, and a post-run focused repair that removes
  the extra disallowed `compute_hash` for future runs. It is still not
  `accepted_by_closure`; the focused repair is not a full 48-fixture v5 rerun
  and does not validate H1-H5.
- A full v5 rerun at
  `docs/04_experiments/results/post_stage_1_larger_sample/20260530_141649/`
  completed with threshold status `pass_acceptance_candidate`. The
  [run report](../05_evaluation/Post_Stage_1_Lane_A_20260530_141649_Run_Report.md)
  and
  [closure candidate](Post_Stage_1_Lane_A_20260530_141649_Closure_Candidate.md)
  record valid required artifacts, replay consistency `1.0`, audit completeness
  `1.0`, treatment task success `0.9792`, and full-run confirmation that the
  `docops_ws_evidence_packet_001` root planner no longer appends the extra
  disallowed `compute_hash`. One expected-rejected structured-selector fixture,
  `docops_struct_selector_missing_001`, still committed in the measured run.
  A later focused repair added a compact missing-selector rejection hint and a
  fixture-oracle selector-failure guard; targeted tests pass, but a 2026-05-31
  full rerun attempt timed out without producing a new complete artifact set.
  The run is not `accepted_by_closure` and does not validate H1-H5.
- A full selector-repair rerun at
  `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/`
  completed with threshold status `pass_acceptance_candidate`. The
  [run report](../05_evaluation/Post_Stage_1_Lane_A_20260601_113121_Run_Report.md)
  and
  [closure](Post_Stage_1_Lane_A_20260601_113121_Closure.md)
  record valid required artifacts, replay consistency `1.0`, audit completeness
  `1.0`, commit integrity `1.0`, treatment task success `1.0000`, process
  integrity hard gates at `0`, and full-run confirmation that
  `docops_struct_selector_missing_001` now rejects the documented missing
  `section` selector. This run is accepted by manifest closure as
  `accepted_by_closure` for the named threshold-governed Lane A Document Ops
  sample. It does not validate H1-H5.
- `PS1-G3` and `PS1-G4` are accepted by
  [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md).
  Label collection remains `Not yet run`.
- The active blinded Lane B packet for the `20260601_113121` Lane A closure run
  is prepared at
  `docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/`,
  with a report skeleton at
  `docs/05_evaluation/Post_Stage_1_Lane_B_20260601_113121_Label_Report_Skeleton.md`.
  It covers `evidence_sufficiency_score`, `context_omission_error_rate`, and
  `working_set_relevance_score` candidates. Human labels, secondary review,
  adjudication, and agreement reporting remain `Not yet run`, so no broad label
  claim exists yet.
- The earlier `20260530_141649` Lane B packet remains as a superseded
  historical packet only. It is not the current accepted-run Lane B source
  because the source run was not `accepted_by_closure` and its
  `docops_struct_selector_missing_001` item captured the pre-repair committed
  artifact.
- `PS1-G6` has a local schema-backed implementation of
  `Document Ops Structured Edit Action Surface v0`, including runtime code,
  schemas, fixtures, and tests. It remains fixture-local and does not create a
  measured validation claim.
- `PS1-G7` is accepted by
  [Context OS Expansion Gate](Context_OS_Expansion_Gate.md) for Context OS
  specification and evaluation planning only. It is separate from `PS1-G6`, and
  full Context OS implementation is not bundled with generic runtime scope
  expansion.
- The first `PS1-G7` planning bundle aligned to the `20260601_113121` Lane A
  closure run is routed through
  [Post-Stage-1 Context OS Planning Draft Spec](../02_specs/Post_Stage_1_Context_OS_Planning_Draft_Spec.md),
  [Post-Stage-1 Context OS Schema Impact Review](../03_schemas/Post_Stage_1_Context_OS_Schema_Impact_Review.md),
  and
  [Post-Stage-1 Context OS Evaluation Plan](../04_experiments/Post_Stage_1_Context_OS_Evaluation_Plan.md).
  Lane A working-set metrics support planning-level budget, provenance,
  omission, relevance, stability, and process-integrity statements. Lane B
  omission and relevance labels remain `Not yet run`, so the bundle remains a
  planning draft and does not authorize implementation, schema changes, learned
  retrieval, memory writes, full Context OS validation, or H3 validation.
- `PS1-G8` is accepted by
  [Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md) for
  side-effect specification and evaluation planning only. Runtime execution of
  `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` actions still requires later
  accepted specs, schemas, fixtures, runtime code, tests, and evaluation
  artifacts.

## Routing Rules

When a required post-Stage-1 artifact is added, update all relevant routing
surfaces in the same change:

- [Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md)
- [Document Map](Document_Map.md)
- [Traceability Matrix](Traceability_Matrix.md)
- the relevant layer index or source document
- mirrored files in `chatgpt_docs/` when the changed source file is already
  mirrored there

Updating this inventory alone does not satisfy a gate. A gate item reaches
`Accepted` only when the required artifact exists and is explicitly accepted by
[Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md) or a successor
manifest gate.
