# Post-Stage-1 Context OS Evaluation Plan

## Purpose

Define the minimum evaluation plan for Context OS planning under `PS1-G7`,
using the `20260601_113121` Lane A closure run as the measured input.

This plan is not an experiment result. It does not run full Context OS, collect
labels, change schemas, or validate H3.

## Status

Plan ID: `PS1-LC-CTX-PLAN-001`.

Plan status: `Context OS planning draft`.

Gate policy version: `PS1-LC-CTX-GATE-001`.

Source Lane A run: `20260601_113121`.

Source threshold status: `pass_acceptance_candidate`.

Closure status: `accepted_by_closure` for the named Lane A Document Ops sample.

Lane B label status: `Not yet run`.

Run status for this plan: `Not yet run`.

Implementation status: `Not authorized`.

## Source Evidence

This plan uses:

- [Post-Stage-1 Lane A 20260601_113121 Run Report](../05_evaluation/Post_Stage_1_Lane_A_20260601_113121_Run_Report.md)
- [Post-Stage-1 Lane A 20260601_113121 Closure](../00_manifest/Post_Stage_1_Lane_A_20260601_113121_Closure.md)
- `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/run.json`
- `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/summary.md`
- `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/fixture_inventory.md`
- [Post-Stage-1 Lane B 20260601_113121 Blinded Label Packet](../05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/README.md)
- [Post-Stage-1 Lane B 20260601_113121 Label Report Skeleton](../05_evaluation/Post_Stage_1_Lane_B_20260601_113121_Label_Report_Skeleton.md)

## Evidence Already Supported By Lane A

| Evidence item | Baseline | Treatment | Interpretation |
| --- | ---: | ---: | --- |
| `working_set_budget_adherence` | `1.0000` | `1.0000` | Structural budget checks can be routed through existing run artifacts. |
| `working_set_provenance_completeness` | `0.6667` | `1.0000` | Treatment provenance completeness is supported structurally. |
| `context_omission_error_rate` | `0.7778` | `0.0000` | Fixture-oracle or structural omission scoring supports planning, not human-labeled claims. |
| `working_set_relevance_score` | `0.2167` | `0.9667` | Fixture-oracle or structural relevance scoring supports planning, not broad Context OS validation. |
| `long_task_stability` | `1.0000` | `1.0000` | Long-context tasks remained stable under the measured treatment. |
| Unsupported commits | `0` | `0` | Process-integrity floor held. |
| Memory writes | `0` | `0` | No memory-write expansion occurred. |
| Disallowed side-effect classes | `0` | `0` | No side-effect expansion occurred. |

The treatment working-set stratum covered six long-context fixtures:

- `docops_ws_evidence_packet_001`
- `docops_ws_irrelevant_context_001`
- `docops_ws_omission_trap_001`
- `docops_ws_recovery_context_001`
- `docops_ws_traceability_long_001`
- `docops_ps1_ws_structured_edit_context_001`

## Evidence Still Not Available

The following remain unavailable because Lane B labels are `Not yet run`:

| Missing evidence | Required before use |
| --- | --- |
| Human-labeled context omission results | Raw labels, frozen primary labels, adjudication where required, and report completion under `PS1-LB-LABEL-001`. |
| Human-labeled working-set relevance results | Double human annotation or documented secondary review plus adjudication and agreement reporting. |
| Broader context-quality interpretation | Complete label source and blinding metadata. |
| Context OS expansion evidence beyond v0 | A later accepted spec, schema decision, fixed arms, and measured run. |
| H3 validation | Not available from this planning batch. |

## Planned Arms

This plan preserves the existing `PS1-G5` baseline identity boundary.

| Arm role | Label | Status |
| --- | --- | --- |
| Context baseline | `raw_trace_bounded_openclaw_agent_local/<model>_matched_budget` | Existing Lane A arm family. |
| Current treatment | `working_set_compiler_v0_reference_backed_openclaw_agent_local/<model>_matched_budget` | Existing `Working Set Compiler v0` arm family. |
| Future Context OS candidate | To be named by a later accepted spec. | Placeholder only; not executable in this plan. |

No arm may be labeled `context_os` unless a later accepted spec defines the
capability and the report states the implementation boundary. OpenClaw local
harness arms must not be reported as pure model-only baselines.

## Fixed Controls For A Future Run

Any future Context OS evaluation run using this plan must fix before execution:

- model identity
- harness identity
- planner, verifier, recovery, and context-planner adapter identities
- prompt character budget
- response character budget
- selected-context budget or an explicit `null` value with rationale
- action-attempt limit
- recovery-attempt limit
- allowed action set
- baseline and treatment arm labels
- compute matching rule
- label policy version and label source
- artifact output path

## Required Metrics

Future reports must include at minimum:

| Metric | Required source |
| --- | --- |
| `working_set_budget_adherence` | Automated structural check. |
| `working_set_provenance_completeness` | Automated structural check, with secondary review if source resolution is disputed. |
| `context_omission_error_rate` | Fixture oracle for Lane A; human, secondary review, or double-human adjudicated for broader Lane B claims. |
| `working_set_relevance_score` | Fixture oracle for Lane A; human, secondary review, or double-human adjudicated for broader Lane B claims. |
| `long_task_stability` | Automated structural and task-outcome checks. |
| unsupported commit count | Must remain `0`. |
| memory-write count | Must remain `0`. |
| disallowed side-effect count | Must remain `0`. |

If human or secondary labels are missing, the report must label subjective
context-quality metrics as fixture-oracle, automated structural, or
`Not yet run`, as applicable.

## Future Artifact Contract

A future run under this plan should write artifacts under:

```text
docs/04_experiments/results/context_os_planning/<timestamp>/
```

Required files:

- `run.json`
- `summary.md`
- `fixture_inventory.md`
- `context_artifact_inventory.md`
- `label_packet_ref.md` or a link to the applicable Lane B packet

The exact machine-readable schema remains the current schema set unless a later
schema batch is accepted.

## Pre-Run Gates

A future Context OS evaluation run must not start until:

| Gate | Required condition |
| --- | --- |
| `PS1-G7` | Context OS planning remains inside `PS1-LC-CTX-GATE-001`. |
| Schema review | The schema impact review is accepted as no-change or superseded by an accepted schema batch. |
| Label boundary | Any human or secondary context-quality claim has a packet and review path under `PS1-LB-LABEL-001`. |
| Baseline identity | Arm labels satisfy `PS1-G5`. |
| Process integrity | Unsupported commits, memory writes, and disallowed side-effect classes are expected to remain `0`. |
| Implementation boundary | Any future candidate arm has an accepted implementation spec before execution. |

## Reporting Labels

Allowed report labels before Lane B labels are collected:

- `Context OS planning draft`
- `context evaluation pilot`
- `Working Set Compiler v0 result without Context OS claim`
- `blocked_missing_lane_b_labels`

Disallowed report labels in this plan:

- Context OS `accepted_by_closure`
- `H3 validated`
- `full Context OS validated`
- `learned retrieval validated`
- `memory governance validated`
- `production ready`

## Non-goals

- This plan does not run an experiment.
- This plan does not collect Lane B labels.
- This plan does not change schemas.
- This plan does not implement full Context OS.
- This plan does not authorize learned retrieval, learned ranking, or
  compression.
- This plan does not authorize memory writes or memory governance.
- This plan does not authorize `COMMITTABLE` or `IRREVERSIBLE` side effects.
- This plan does not validate H3.

## Related Documents

- [Post-Stage-1 Context OS Planning Draft Spec](../02_specs/Post_Stage_1_Context_OS_Planning_Draft_Spec.md)
- [Post-Stage-1 Context OS Schema Impact Review](../03_schemas/Post_Stage_1_Context_OS_Schema_Impact_Review.md)
- [Context OS Expansion Gate](../00_manifest/Context_OS_Expansion_Gate.md)
- [Context OS and Working Set Compiler Note](../02_specs/Context_OS_and_Working_Set_Compiler_Note.md)
- [Post-Stage-1 Lane A 20260601_113121 Run Report](../05_evaluation/Post_Stage_1_Lane_A_20260601_113121_Run_Report.md)
- [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md)
- [Post-Stage-1 Lane B 20260601_113121 Label Report Skeleton](../05_evaluation/Post_Stage_1_Lane_B_20260601_113121_Label_Report_Skeleton.md)
