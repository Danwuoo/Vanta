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

Lane C has accepted `PS1-G6` for implementation planning only:
[Post-Stage-1 Runtime Scope Proposal](Post_Stage_1_Runtime_Scope_Proposal.md)
names `Document Ops Structured Edit Action Surface v0` as the next runtime
capability. It stays inside fixture-local Document Ops and does not implement
new actions, update runtime schema enums, approve full Context OS, or expand
side-effect classes.

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
