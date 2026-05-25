# Project Manifest

## Purpose

Vanta is a research and engineering program for an agent runtime centered on learned cognition, executable action, evidence, verification, context governance, memory discipline, failure attribution, and replay-safe execution.

This manifest defines the documentation system and prevents theory documents from directly controlling implementation without passing through specs, schemas, experiments, and evaluation.

## Documentation Layers

| Layer | Directory | Role |
| --- | --- | --- |
| L0 | `00_manifest` | Governance, scope, traceability, terminology, and document operations |
| L1 | `01_theory` | Source theory, research hypotheses, validation review, and alternative theories |
| L2 | `02_specs` | Implementable MVP specifications derived from the theory layer |
| L3 | `03_schemas` | Interoperable runtime, benchmark, and evaluation data contracts |
| L4 | `04_experiments` | Benchmark and ablation experiment design |
| L5 | `05_evaluation` | Metrics, labeling guides, and report templates |
| L6 | `06_engineering` | Architecture, module planning, timeline, and testing strategy |

## Governance Rules

- `Design_Theory.md` is the conceptual source of truth, not an implementation spec.
- `Validation_and_Refutation_Report.md` is an evidence and risk review, not proof of validation.
- Engineering work must be justified by specs, schemas, and tests, not by theory prose alone.
- Experimental claims must remain `TODO`, `Not yet run`, or `Open Questions` until measured.
- Changes to core concepts must update the traceability matrix and decision log.

## MVP Positioning

The MVP should focus on the minimal closed loop:

```text
state -> plan -> action -> evidence -> verify -> commit / abort
```

Targeted recovery, Context OS, long-term memory governance, and advanced execution governance should be staged after the minimal loop has measurable behavior.

After the five Stage 1 local smoke closures, advancement beyond local smoke is
controlled by [Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md).
The closures are prerequisites for larger samples, human or secondary labeling,
and broader runtime scope. They are not validation by themselves.

Lane A planning has accepted `PS1-G1` and `PS1-G5`: the first larger controlled
Document Ops frame is 48 fixtures, and OpenClaw remains a local harness baseline
supplemented by separately named direct API arms when available. Lane A metric
thresholds are accepted by `PS1-G2`, so larger-sample runs can become
threshold-governed acceptance candidates after measured results and closure
acceptance.

Lane B labeling policy has accepted `PS1-G3` and `PS1-G4`: evidence
sufficiency labels use the `PS1-LB-LABEL-001` five-level scale, and subjective
or oracle-sensitive labels require the documented review and adjudication path.
No post-Stage-1 human or secondary labels have been collected yet.

Lane C has implemented the `PS1-G6` local runtime batch:
[Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md)
names `Document Ops Structured Edit Action Surface v0`; the G6 batch adds
schema-backed fixture-local `READ_ONLY`, `SIMULATED`, and `REVERSIBLE`
structured edit actions, fixtures, and local tests. It does not approve full
Context OS, expand side-effect classes, collect measured experiment results, or
validate H1-H5.

Lane A has a G6-aware execution successor frame:
[Post-Stage-1 Larger Sample G6 Successor Plan](../04_experiments/Post_Stage_1_Larger_Sample_G6_Successor_Plan.md)
defines `PS1-LA-SAMPLE-002` as the 48-fixture, 8-stratum execution frame for
larger controlled sample runs after structured edit implementation. The local
runner `Vanta.PostStage1LargerSample` can produce `run.json`, `summary.md`, and
`fixture_inventory.md` under
`docs/04_experiments/results/post_stage_1_larger_sample/<timestamp>/` and can
only report `blocked_missing_metric`, `failed_no_acceptance`, or
`pass_acceptance_candidate` before manifest closure. No measured Lane A
acceptance closure has been accepted yet. The first measured `PS1-LA-SAMPLE-002`
run completed at
`docs/04_experiments/results/post_stage_1_larger_sample/20260519_232854/` with
threshold status `failed_no_acceptance`; the corresponding
[Post-Stage-1 Lane A 20260519_232854 Run Report](../05_evaluation/Post_Stage_1_Lane_A_20260519_232854_Run_Report.md)
and
[closure candidate](Post_Stage_1_Lane_A_20260519_232854_Closure_Candidate.md)
record required-artifact, replay, and audit blockers. It is not
`accepted_by_closure`. A repair-batch rerun completed at
`docs/04_experiments/results/post_stage_1_larger_sample/20260522_012221/` with
threshold status `failed_no_acceptance`; the corresponding
[Post-Stage-1 Lane A 20260522_012221 Run Report](../05_evaluation/Post_Stage_1_Lane_A_20260522_012221_Run_Report.md)
and
[closure candidate](Post_Stage_1_Lane_A_20260522_012221_Closure_Candidate.md)
record remaining task-success, required-artifact, replay, and audit blockers.
It is also not `accepted_by_closure`. A compact fixture-alignment rerun
completed at
`docs/04_experiments/results/post_stage_1_larger_sample/20260523_223106/`
with threshold status `pass_acceptance_candidate`; the corresponding
[Post-Stage-1 Lane A 20260523_223106 Run Report](../05_evaluation/Post_Stage_1_Lane_A_20260523_223106_Run_Report.md)
and
[closure candidate](Post_Stage_1_Lane_A_20260523_223106_Closure_Candidate.md)
record threshold-passing candidate status, residual expected-rejected fixture
follow-up, and the boundary that no `accepted_by_closure` or H1-H5 validation
claim is created.

Lane C has accepted `PS1-G7` for Context OS specification and evaluation
planning only:
[Context OS Expansion Gate](Context_OS_Expansion_Gate.md) defines the
conditions for moving beyond deterministic `Working Set Compiler v0`. It does
not implement full Context OS, change schemas, authorize learned retrieval or
compression, approve memory governance, collect labels, run experiments, or
validate H3.

Lane C has accepted `PS1-G8` for side-effect specification and evaluation
planning only:
[Side-Effect Escalation Gate](Side_Effect_Escalation_Gate.md) defines the
conditions for planning beyond Stage 1 side-effect allowances. It does not
authorize runtime execution of `COMMITTABLE`, `IRREVERSIBLE`, or
`MEMORY_WRITE` actions, change schemas, collect labels, run experiments,
approve production deployment, or validate H5.

## Source Documents

- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
