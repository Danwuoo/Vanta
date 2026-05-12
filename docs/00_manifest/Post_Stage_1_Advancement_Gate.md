# Post-Stage-1 Advancement Gate

## Purpose

Define the advancement conditions after Experiments 001 through 005 have all
closed as local smoke runs.

This gate converts post-Stage-1 open questions into trackable gate items. It
does not validate the architecture, approve runtime implementation by itself, or
replace future experiment and evaluation reports.

## Status

Accepted as the active post-Stage-1 advancement gate on 2026-05-09.

The five local smoke closures are prerequisites for post-smoke planning. They
are not statistical support for H1, H2, H3, H4, H5, full Context OS, or a
general-purpose runtime.

## Inputs

| Closure | Closed scope | Fixture count | Interpretation boundary |
| --- | --- | ---: | --- |
| [Stage 1 Experiment 001 Closure](Stage_1_Experiment_001_Closure.md) | Minimal closed loop local smoke | 7 | Not broad validation of H1. |
| [Stage 1 Experiment 002 Closure](Stage_1_Experiment_002_Closure.md) | Evidence and verifier hardening local smoke | 7 | Not broad validation of H2. |
| [Stage 1 Experiment 003 Closure](Stage_1_Experiment_003_Closure.md) | Journal, audit, and replay local smoke | 7 | Not broad validation of H5. |
| [Stage 1 Experiment 004 Closure](Stage_1_Experiment_004_Closure.md) | Targeted recovery local smoke | 3 | Not broad validation of H4. |
| [Stage 1 Experiment 005 Closure](Stage_1_Experiment_005_Closure.md) | Working Set Compiler v0 local smoke | 5 | Not broad validation of H3 or full Context OS. |

## Advancement Rule

After the five local smoke closures, advancement is allowed only into one of
three explicitly gated lanes:

1. Larger controlled samples.
2. Human or secondary labeling.
3. Broader runtime scope.

Each lane must satisfy its own gate before work in that lane is reported as a
post-Stage-1 advancement. A run may still be performed as an exploratory pilot
when a gate is incomplete, but it must be labeled as an exploratory pilot and
must not be used for broader validation claims.

## Lane A: Larger Controlled Samples

The program may advance from local smoke fixtures to a larger controlled
Document Ops sample only when all conditions below are met.

| Gate item | Required condition |
| --- | --- |
| Sample frame | A versioned experiment plan defines fixture count, fixture families, inclusion rules, exclusion rules, and coverage across minimal loop, verifier, journal/replay, recovery, and working-set cases. |
| Fixed controls | Backbone model, harness label, tool interface, prompt budget, response budget, action-attempt limits, and compute-matching rules are fixed before execution. |
| Baseline identity | OpenClaw local harness baselines remain labeled as OpenClaw harness runs. A direct Responses or other pure model-only baseline requires a separately named arm. |
| Metric policy | Metrics, thresholds, no-regression checks, and reporting rules are fixed before execution. Missing thresholds allow data collection, but not acceptance claims. |
| Artifact contracts | Required schemas and run artifact locations are fixed before execution. Run reports must link machine-readable results and closure documents. |
| Process-integrity floor | Unsupported commits must remain `0`. Memory writes must remain `0` unless a separate memory-write gate is accepted. |

Minimum reporting for a larger controlled sample must include:

- `task_success_rate`
- `invalid_action_rate`
- `verifier_false_accept_rate`
- `verifier_false_reject_rate`
- `evidence_sufficiency_score`
- `commit_integrity_score`
- `replay_consistency`
- `audit_completeness`
- recovery metrics from Phase 4 when recovery fixtures are included
- working-set metrics from Phase 5 when long-context fixtures are included

## Lane B: Human Or Secondary Labeling

The program may advance to human or secondary labeling only when all conditions
below are met.

| Gate item | Required condition |
| --- | --- |
| Labeling scope | A versioned labeling plan maps each target metric to a label type, artifact packet, label guide, and adjudication path. |
| Label scale | Label scales are fixed before annotation begins, including the evidence sufficiency scale. |
| Double annotation | Double human annotation or documented secondary review is required for subjective or oracle-sensitive metrics. |
| Blinding and identity | Label packets specify what annotators may see, preserve evaluator identity, and separate fixture oracle metadata from treatment-visible runtime inputs. |
| Disagreement handling | The plan defines inter-annotator agreement reporting and adjudication rules before labels are collected. |
| Runtime boundary | Human labels are evaluation artifacts only. They are not a human-in-the-loop verifier or runtime approval path unless a separate spec says so. |

Double annotation or secondary review is required before broad claims for:

- `evidence_sufficiency_score`
- `verifier_false_accept_rate`
- `verifier_false_reject_rate`
- `audit_completeness` when used as a broader reviewability measure
- `failure_label_accuracy`
- `targeted_recovery_success` when recovery policy choice is not fixture-trivial
- `context_omission_error_rate` when fixture required refs are incomplete
- `working_set_relevance_score`

Automated checks may remain single-source when they are purely structural, such
as schema validation, budget adherence, provenance completeness, unsupported
commit counts, memory-write counts, and replay consistency in deterministic
fixtures.

## Lane C: Broader Runtime Scope

The program may advance beyond the current Stage 1 runtime scope only when all
conditions below are met.

| Gate item | Required condition |
| --- | --- |
| Scope proposal | A manifest or spec document names the new domain, runtime capability, side-effect classes, and non-goals. |
| Spec and schema path | Specs and schemas are updated before implementation. Theory prose alone cannot authorize runtime expansion. |
| Evidence and verifier path | New action types define required Evidence Packet fields, verifier checks, journal fields, and acceptance criteria. |
| Rollback or compensation | Reversible, compensable, and non-reversible effects are separated. Rollback must not be assumed. |
| Evaluation plan | A benchmark, metric policy, and label plan exist before broader-scope results are reported as advancement evidence. |
| Process-integrity floor | Unsupported commits remain `0`; ungoverned memory writes remain `0`; side-effect classes stay within their accepted gate. |

Scope escalation is not bundled. Each of the following requires its own accepted
gate or explicitly named successor policy. `PS1-G8` covers side-effect
specification and evaluation planning for the listed high-risk side-effect
classes, but it does not authorize runtime execution:

- full Context OS beyond `Working Set Compiler v0`
- learned retrieval, ranking, or compression
- long-term memory governance
- `MEMORY_WRITE` effects
- `COMMITTABLE` external effects
- `IRREVERSIBLE` effects
- model-based verifier runtime
- human-in-the-loop verifier runtime
- production deployment
- non-Document-Ops benchmark domains

## Trackable Gate Items

| Gate ID | Open question absorbed | Required artifact | Blocks |
| --- | --- | --- | --- |
| `PS1-G0` | Have all five local smoke closures been recorded without broad validation claims? | Closure docs 001 through 005 and linked run reports | Any post-Stage-1 advancement |
| `PS1-G1` | What sample size is feasible for broader experiments? | [Post-Stage-1 Larger Sample Plan](../04_experiments/Post_Stage_1_Larger_Sample_Plan.md) | Larger controlled samples |
| `PS1-G2` | What metric thresholds define MVP acceptance beyond local smoke? | [Post-Stage-1 Metric Policy](../05_evaluation/Post_Stage_1_Metric_Policy.md) | Larger controlled samples and acceptance claims |
| `PS1-G3` | What label scale should be used for evidence sufficiency? | [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md) | Human or secondary labeling |
| `PS1-G4` | Which metrics require double human annotation? | [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md) | Human or secondary labeling |
| `PS1-G5` | Should the OpenClaw candidate baseline be promoted, replaced, or supplemented? | [Baseline Identity Plan](../04_experiments/Baseline_Identity_Plan.md) | Larger controlled samples |
| `PS1-G6` | Which runtime capability may expand next? | [Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md) | Local structured edit runtime implementation |
| `PS1-G7` | When can Context OS expand beyond Working Set Compiler v0? | [Context OS Expansion Gate](Context_OS_Expansion_Gate.md) | Context OS specification and evaluation planning |
| `PS1-G8` | When can side-effect classes expand beyond Stage 1 allowances? | [Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md) | `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` planning |

`PS1-G0` is met by the current closure set. `PS1-G1` is accepted by the
larger-sample plan, `PS1-G2` is accepted by the metric policy, `PS1-G3` and
`PS1-G4` are accepted by the labeling scope and adjudication policy, and
`PS1-G5` is accepted by the baseline identity plan. `PS1-G6` is accepted by
[Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md)
and has a local schema-backed implementation of `Document Ops Structured Edit
Action Surface v0`. It adds runtime code, schemas, fixtures, and tests, but it
does not authorize broader runtime validation claims. `PS1-G7` is accepted
by [Context OS Expansion Gate](Context_OS_Expansion_Gate.md) for Context OS
specification and evaluation planning only. It does not implement full Context
OS, change schemas, authorize learned retrieval or compression, approve memory
governance, collect labels, run experiments, or validate H3. `PS1-G8` is
accepted by [Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md) for
side-effect specification, schema impact review, evaluation planning, and
implementation planning only. It does not authorize runtime execution of
`COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` actions, change schemas,
collect labels, run experiments, approve production deployment, or validate H5.

Lane A is open for threshold-governed larger-sample acceptance candidates after
the 48-fixture sample is run under the accepted sample, metric, and baseline
identity policies. A future manifest closure must still accept measured results
before a report may use `accepted_by_closure`.

Lane B is open for human or secondary labeling after labels are collected under
[Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md).
No post-Stage-1 human or secondary labels have been collected yet, and a future
report must still include packet, blinding, review, adjudication, agreement,
and interpretation-boundary metadata before using broader label claims.

Lane C has a local implementation of `Document Ops Structured Edit Action
Surface v0` under
[Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md).
The accepted scope remains fixture-local Document Ops and only uses
`READ_ONLY`, `SIMULATED`, and `REVERSIBLE` structured actions. Larger measured
claims still require future experiment and evaluation artifacts.

Lane C is also open for Context OS specification and evaluation planning under
[Context OS Expansion Gate](Context_OS_Expansion_Gate.md). The accepted
`PS1-G7` scope remains planning-only and keeps `Working Set Compiler v0` as the
current implemented context capability.

Lane C is also open for side-effect specification and evaluation planning under
[Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md). The accepted
`PS1-G8` scope remains planning-only. `COMMITTABLE`, `IRREVERSIBLE`, and
`MEMORY_WRITE` execution still requires later accepted specs, schemas,
fixtures, runtime code, tests, and evaluation artifacts.

## Gate Inventory Boundary

[Post-Stage-1 Gate Inventory](Post_Stage_1_Gate_Inventory.md) tracks artifact
status, proposed artifact paths, dependencies, and routing for `PS1-G1` through
`PS1-G8`. This document remains the normative source for post-Stage-1 gate
conditions. The inventory cannot replace any required artifact and cannot
accept a gate item by itself.

## Non-goals

- The five local smoke closures are not broad validation.
- This gate does not define final MVP acceptance thresholds by itself; `PS1-G2`
  thresholds are defined by
  [Post-Stage-1 Metric Policy](../05_evaluation/Post_Stage_1_Metric_Policy.md).
- This gate does not authorize full Context OS implementation or validation,
  learned retrieval implementation, compression implementation, or memory
  governance.
- This gate does not authorize memory writes, training, or learning from runtime
  feedback.
- This gate does not authorize irreversible external actions.
- This gate does not authorize production deployment.
- Human labels collected under this gate are evaluation labels, not runtime
  approval decisions.
- Fixture oracle labels are not universal human ground truth.
- OpenClaw local harness results must not be relabeled as pure model-only
  results.

## Reporting Requirements

Any post-Stage-1 run, labeling effort, or scope expansion must report:

- the lane it advances
- the gate IDs satisfied or still open
- exact baseline and treatment arm labels
- model and harness identity
- fixture count and fixture family coverage
- metric policy version
- label policy version, when labels are used
- result path and machine-readable artifact path
- interpretation boundaries

Reports that do not satisfy the relevant lane gate must use labels such as
`exploratory pilot`, `labeling pilot`, or `scaled local run without acceptance
claim`.

## Related Documents

- [Project Manifest](Project_Manifest.md)
- [Stage 1 MVP Entry Gate](Stage_1_MVP_Entry_Gate.md)
- [Stage 1 Experiment 005 Closure](Stage_1_Experiment_005_Closure.md)
- [Post-Stage-1 Gate Inventory](Post_Stage_1_Gate_Inventory.md)
- [Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md)
- [Context OS Expansion Gate](Context_OS_Expansion_Gate.md)
- [Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md)
- [Post-Stage-1 Larger Sample Plan](../04_experiments/Post_Stage_1_Larger_Sample_Plan.md)
- [Baseline Identity Plan](../04_experiments/Baseline_Identity_Plan.md)
- [Metrics Definition](../05_evaluation/Metrics_Definition.md)
- [Post-Stage-1 Metric Policy](../05_evaluation/Post_Stage_1_Metric_Policy.md)
- [Post-Stage-1 Labeling Scope and Adjudication Policy](../05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy.md)
- [Ablation Plan](../04_experiments/Ablation_Plan.md)
- [Implementation Timeline](../06_engineering/Implementation_Timeline.md)
