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
| `PS1-G1` | Larger Controlled Samples | `Accepted` | [Post-Stage-1 Larger Sample Plan](../04_experiments/Post_Stage_1_Larger_Sample_Plan.md) | `docs/04_experiments/Post_Stage_1_Larger_Sample_Plan.md` | `PS1-G0`; Document Ops benchmark; closure reports 001 through 005 | Larger controlled sample planning; input to `PS1-G2` | Acceptance claims require the accepted metric policy and measured results. |
| `PS1-G2` | Larger Controlled Samples | `Accepted` | [Post-Stage-1 Metric Policy](../05_evaluation/Post_Stage_1_Metric_Policy.md) | `docs/05_evaluation/Post_Stage_1_Metric_Policy.md` | `PS1-G1`; `PS1-G5`; metrics definition; closure reports 001 through 005 | Threshold-governed acceptance candidates for larger controlled samples | Passing thresholds is not broad validation and still requires measured run reports plus closure acceptance. |
| `PS1-G3` | Human or Secondary Labeling | `Accepted` | [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md) | `docs/05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md` | `PS1-G0`; Evidence Packet spec; Metrics Definition; labeling guides | Evidence sufficiency labeling can begin under the fixed `PS1-LB-LABEL-001` scale | Evidence sufficiency labels have not been collected; no broad label claim exists yet. |
| `PS1-G4` | Human or Secondary Labeling | `Accepted` | [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md) | `docs/05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md` | `PS1-G0`; `PS1-G3`; labeling guides | Broader subjective label claims can use the accepted review and adjudication policy after labels are collected | Subjective metrics cannot support broad claims without policy-compliant packets, review, and adjudication records. |
| `PS1-G5` | Larger Controlled Samples | `Accepted` | [Baseline Identity Plan](../04_experiments/Baseline_Identity_Plan.md) | `docs/04_experiments/Baseline_Identity_Plan.md` | `PS1-G0`; OpenClaw local harness closure notes; Experiment 001 baseline records | Baseline arm naming for larger controlled samples; input to `PS1-G2` | OpenClaw harness results are not promoted to pure model-only baseline results. |
| `PS1-G6` | Broader Runtime Scope | `Accepted` | [Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md) | `docs/00_manifest/Post_Stage_1_Runtime_Scope_Proposal.md` | `PS1-G0`; Stage 1 scope boundaries; Execution IR, Evidence Packet, Commit/Abort/Replay specs | Implementation planning for `Document Ops Structured Edit Action Surface v0` | Runtime implementation is not complete; schemas, code, fixtures, and tests still require a later batch. |
| `PS1-G7` | Broader Runtime Scope | `Accepted` | [Context OS Expansion Gate](Context_OS_Expansion_Gate.md) | `docs/00_manifest/Context_OS_Expansion_Gate.md` | `PS1-G0`; Phase 5 gate; Experiment 005 closure; Working Set Compiler note; `PS1-G1` through `PS1-G5` policies | Context OS specification and evaluation planning only | Runtime implementation, schema changes, full Context OS validation, learned retrieval, compression, memory governance, and H3 validation are not authorized. |
| `PS1-G8` | Broader Runtime Scope | `Accepted` | [Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md) | `docs/00_manifest/Side_Effect_Escalation_Gate.md` | `PS1-G0`; Stage 1 side-effect allowances; Commit Abort Replay Semantics; Evidence Packet and Verifier Runtime | Side-effect specification, schema impact review, evaluation planning, and implementation planning | Runtime execution of `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` actions is not authorized; rollback must not be assumed. |

## Dependency Order

- `PS1-G1`, `PS1-G2`, and `PS1-G5` are accepted and provide the Lane A sample,
  metric, and baseline identity policies.
- `PS1-G3` and `PS1-G4` are accepted by
  [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md).
  Label collection remains `Not yet run`.
- `PS1-G6` is accepted for implementation planning of
  `Document Ops Structured Edit Action Surface v0`. It does not update runtime
  schema enums or implement the action surface.
- `PS1-G7` is accepted by
  [Context OS Expansion Gate](Context_OS_Expansion_Gate.md) for Context OS
  specification and evaluation planning only. It is separate from `PS1-G6`, and
  full Context OS implementation is not bundled with generic runtime scope
  expansion.
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
