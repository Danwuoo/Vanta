# Post-Stage-1 Lane B 20260601_113121 Label Report Skeleton

## Experiment

- Source experiment ID: `post_stage_1_larger_sample`
- Source sample frame: `PS1-LA-SAMPLE-002`
- Source Lane A run timestamp: `20260601_113121`
- Source Lane A closure status: `accepted_by_closure`
- Lane B packet ID: `PS1-LB-PACKET-20260601-113121-BATCH-001`
- Label policy version: `PS1-LB-LABEL-001`
- Metric policy version: `PS1-LA-METRIC-001`
- Context gate policy version: `PS1-LC-CTX-GATE-001`
- Label collection status: `Not yet run`
- Report status: `Not yet run`
- Claim level before labels: prepared blinded label packet only

## Source Artifacts

| Artifact | Path |
| --- | --- |
| Source run JSON | `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/run.json` |
| Source run summary | `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/summary.md` |
| Source fixture inventory | `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/fixture_inventory.md` |
| Lane A run report | `docs/05_evaluation/Post_Stage_1_Lane_A_20260601_113121_Run_Report.md` |
| Lane A closure | `docs/00_manifest/Post_Stage_1_Lane_A_20260601_113121_Closure.md` |
| Label packet manifest | `docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/packet_manifest.json` |
| Redacted task packets | `docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/redacted_task_packets/` |
| Evidence sufficiency items | `docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/evidence_sufficiency_items.jsonl` |
| Working-set context items | `docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/working_set_context_items.jsonl` |
| Adjudication placeholders | `docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/adjudication_placeholders.json` |
| Label result import template | `docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/label_results_template.json` |

## Supersession Boundary

This report skeleton supersedes
`Post_Stage_1_Lane_B_20260530_141649_Label_Report_Skeleton.md` as the active
Lane B reporting shell. The older skeleton remains a historical shell for the
non-accepted `20260530_141649` source run and its prepared packet only.

The older packet must not be used as the current Lane B source for accepted
post-Stage-1 routing because its source run was not `accepted_by_closure` and
its `docops_struct_selector_missing_001` item records the pre-repair committed
artifact. No labels had been collected for that older packet before this
rebuild.

## Labeling Contract

| Metric | Item count | Review mode | Label source | Status |
| --- | ---: | --- | --- | --- |
| `evidence_sufficiency_score` | 8 | `double_human_adjudicated` | `human` | `Not yet run` |
| `context_omission_error_rate` | 12 | `double_human_adjudicated` | `human` | `Not yet run` |
| `working_set_relevance_score` | 12 | `double_human_adjudicated` | `human` | `Not yet run` |

Reviewer identity policy: anonymized reviewer IDs are allowed, but each raw
label must preserve a stable reviewer ID.

Fixture oracle metadata exposed before label freeze: `no`.

Blinding policy: primary labelers see only the packet item records, referenced
redacted task packets, fixture input artifacts, redacted candidate-ref
inventories, and blinded context arm names. Fixture oracle role fields, original
`input_artifacts.role` and `input_artifacts.description` fields, arm identity
mapping, expected labels, task success flags, aggregate item metrics, and
post-run repair notes remain withheld until labels are frozen.

The packet-local label result format is
`PS1-LB-LABEL-RESULT-LOCAL-001`. It is a local collection/import template
for this Lane B packet and does not extend core runtime schemas.

## Collection, Import, Validation, And Reporting Flow

Label collection remains `Not yet run` until real reviewer labels are
imported from a filled result file and validated under `PS1-LB-LABEL-001`.
The template file is not label evidence.

Reviewer fields for evidence sufficiency raw labels:

- `metric: evidence_sufficiency_score`
- `item_id`
- `label_source: human`
- `reviewer_id`
- `raw_label_0_to_4_or_needs_review`
- `confidence`
- `rationale`
- `referenced_artifact_ids`

Reviewer fields for working-set raw labels:

- `metric: working_set_context`
- `item_id`
- `label_source: human`
- `reviewer_id`
- `omission` fields for severity, omitted task-critical refs,
  task-critical candidate refs, `critical_omission`, and denominator refs
- `per_ref_relevance_labels`
- `packet_relevance_quality`
- `confidence`
- `rationale`
- `referenced_artifact_ids`

Required sequence:

1. Freeze the blinded packet and distribute only primary-labeler-visible
   packet files.
2. Collect raw primary labels with stable reviewer IDs and no fixture oracle
   exposure.
3. Freeze primary labels before fixture oracle fields, arm identity mapping,
   source task oracle fields, or aggregate Lane A item results are exposed.
4. Validate the filled result file with
   `mix vanta.post_stage_1_lane_b_label_results --mode validate --results <filled-results.json>`.
5. Complete documented secondary review only if the report records the
   substitution allowed by `PS1-LB-LABEL-001`.
6. Complete adjudication records for all validator-triggered disagreements,
   `needs_review` labels, evidence `0-2` versus `3-4` splits, harmful
   relevance labels, task-critical disputes, critical-omission disputes, and
   denominator disputes.
7. Produce an import summary with
   `mix vanta.post_stage_1_lane_b_label_results --mode import-summary --results <filled-results.json> --out <summary.json>`.
8. Fill this report only from real labels, adjudicated labels, agreement
   counts, fixture-oracle exposure metadata, and the validated import
   summary.

## Candidate Sample

Evidence sufficiency candidates:

| Item | Task | Stratum | Source item file |
| --- | --- | --- | --- |
| `lb20260601-es-001` | `docops_read_traceability_001` | `traceability_extraction` | `evidence_sufficiency_items.jsonl` |
| `lb20260601-es-002` | `docops_struct_contract_fail_001` | `terminology_consistency` | `evidence_sufficiency_items.jsonl` |
| `lb20260601-es-003` | `docops_simulate_patch_001` | `simulated_patch_and_diff` | `evidence_sufficiency_items.jsonl` |
| `lb20260601-es-004` | `docops_struct_apply_reversible_001` | `reversible_edit_and_commit` | `evidence_sufficiency_items.jsonl` |
| `lb20260601-es-005` | `docops_struct_selector_missing_001` | `invalid_action_and_path_guard` | `evidence_sufficiency_items.jsonl` |
| `lb20260601-es-006` | `docops_wrong_diff_001` | `evidence_and_verifier_challenge` | `evidence_sufficiency_items.jsonl` |
| `lb20260601-es-007` | `docops_rollback_failure_001` | `journal_replay_and_recovery` | `evidence_sufficiency_items.jsonl` |
| `lb20260601-es-008` | `docops_ws_evidence_packet_001` | `working_set_long_context` | `evidence_sufficiency_items.jsonl` |

Working-set candidates:

| Task | Blinded arms | Source item file |
| --- | --- | --- |
| `docops_ws_evidence_packet_001` | `context_arm_A`, `context_arm_B` | `working_set_context_items.jsonl` |
| `docops_ws_irrelevant_context_001` | `context_arm_A`, `context_arm_B` | `working_set_context_items.jsonl` |
| `docops_ws_omission_trap_001` | `context_arm_A`, `context_arm_B` | `working_set_context_items.jsonl` |
| `docops_ws_recovery_context_001` | `context_arm_A`, `context_arm_B` | `working_set_context_items.jsonl` |
| `docops_ws_traceability_long_001` | `context_arm_A`, `context_arm_B` | `working_set_context_items.jsonl` |
| `docops_ps1_ws_structured_edit_context_001` | `context_arm_A`, `context_arm_B` | `working_set_context_items.jsonl` |

## Label Results

Human labels have not been collected.

| Metric | Raw labels | Adjudicated labels | Score | `needs_review` count | Status |
| --- | --- | --- | --- | --- | --- |
| `evidence_sufficiency_score` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` |
| `context_omission_error_rate` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` |
| `working_set_relevance_score` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` |

## Adjudication

Adjudication status: `Not yet run`.

Required adjudication triggers:

- any reviewer marks `needs_review`
- evidence sufficiency labels differ by two or more levels
- evidence sufficiency labels split across the `0-2` versus `3-4`
  acceptability boundary
- reviewers disagree on `task_critical`, `critical_omission`, `harmful`, or
  denominator fields for working-set metrics

Adjudication records must include original labels, adjudicated label,
adjudicator ID, rationale, artifact refs inspected, and whether fixture oracle
metadata was exposed.

## Agreement

Inter-annotator agreement: `Not yet run`.

If this first active batch remains too small for stable agreement statistics,
report raw agreement counts and state that agreement statistics are not
meaningful at the sample size.

## Interpretation Boundaries

Allowed before labels are collected:

- The `20260601_113121` Lane A closure run has a prepared blinded Lane B label
  packet.
- The packet includes candidate artifact paths, review modes, blinding
  boundary, supersession boundary, and adjudication placeholders for the three
  named metrics.

Disallowed before labels are collected:

- human-labeled broader evaluation evidence
- new `accepted_by_closure` status beyond the Lane A source closure
- H1-H5 validation
- full Context OS validation
- production readiness
- human-in-the-loop verifier or runtime approval claims
- replacing the measured Lane A aggregate metrics with label results

## Findings

`Not yet run`.

## Failures And Risks

`Not yet run`.

## Next Steps

1. Freeze the primary labeling packet and distribute only the blinded item
   files and referenced source artifacts to reviewers.
2. Collect two independent labels per item or record an allowed secondary
   review substitution.
3. Freeze primary labels before exposing fixture oracle fields or arm identity
   mappings.
4. Complete adjudication records for all required disagreements.
5. Fill this report with raw labels, adjudicated labels, agreement counts, and
   interpretation boundaries.
