# Execution IR and Episode Semantics

## Purpose

Define how planned actions are represented as executable, auditable, and replay-aware steps without turning Execution IR into a second reasoning state.

## Scope

- Execution step identity.
- Action payloads.
- Dependencies.
- Preconditions and postconditions.
- Side-effect classes.
- Commit and rollback grouping.
- Episode step statuses.

## Non-goals

- Encoding the full reasoning state inside Execution IR.
- Defining every tool adapter.
- Supporting irreversible actions without escalation policy.

## Inputs

- Candidate plan or action proposal.
- Current canonical state summary.
- Action schema registry.
- Runtime constraints.
- Verifier requirements.

## Outputs

- One or more `ExecutionStep` records.
- Dependency graph metadata.
- Side-effect class assignment.
- Rollback or compensation policy reference.
- Episode Journal references.

## Key Concepts

- Execution IR describes action semantics, not cognition.
- Tool outputs must be normalized into observations before influencing canonical state.
- Execution records and raw tool logs must not be treated as canonical state.
- Dependency edges should represent causal, evidence, or ordering constraints.
- Side-effect class determines governance requirements.
- Phase 4 represents compensable but non-strictly-rollbackable local fixture
  actions with `COMPENSABLE` and a compensation policy reference.

## PS1-G6 Structured Edit Action Surface

`PS1-G6` implements `Document Ops Structured Edit Action Surface v0` as a
fixture-local runtime interface. The action names are schema-backed in
`execution_step.schema.json`, `planner_action_sequence.schema.json`, and
`benchmark_task.schema.json`, and the runtime executes them through the same
task action allowlists, side-effect allowlists, workspace path guards, Evidence
Packet construction, Verifier Runtime checks, Commit Controller handling, and
Episode Journal audit records as the existing Stage 1 actions.

| Action | Side-effect class | Execution IR requirement |
| --- | --- | --- |
| `inspect_document_structure` | `READ_ONLY` | Must target a fixture-local document path and record a parsed structure summary without mutation. |
| `validate_document_contract` | `READ_ONLY` | Must target a fixture-local document path plus a fixture-local or inline contract and record pass/fail details without mutation. |
| `simulate_structured_edit` | `SIMULATED` | Must identify a structured target, produce candidate content, diff, before/after hashes, and keep the source hash unchanged. |
| `apply_reversible_structured_edit` | `REVERSIBLE` | Must identify a structured target, write only inside the fixture workspace, use `fixture_backup_restore`, and include backup metadata. |

The structured selector contract supports:

- `heading`: `type`, `text`, optional `level`, optional `occurrence`
- `section`: `type`, `heading`, optional `level`, optional `occurrence`
- `line_range`: `type`, `start_line`, `end_line`
- `json_path`: `type`, `path`, optional `occurrence`

Structured edit operations are `replace`, `insert_before`, and `insert_after`.
`simulate_structured_edit` uses `rollback_policy: not_applicable`.
`apply_reversible_structured_edit` must use
`rollback_policy: fixture_backup_restore` and payload
`backup_policy: fixture_backup_restore`.

Selectors must resolve to exactly one target unless an explicit valid
`occurrence` selects one target from multiple matches. Missing or ambiguous
selectors are rejected before commit. `COMPENSABLE` remains limited to the
existing Phase 4 fixture-local receipt treatment and is not expanded by
`PS1-G6`.

## PS1-G8 Side-Effect Escalation Boundary

[Side-Effect Escalation Gate](../00_manifest/Side_Effect_Escalation_Gate.md)
accepts `PS1-G8` for side-effect specification, schema impact review,
evaluation planning, and implementation planning only. It does not authorize
runtime execution of `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` actions.

Future Execution IR work for these classes must define target identity,
preconditions, postconditions, approval policy references, verifier
requirements, rollback or compensation status, and journal references before
any action becomes executable. `IRREVERSIBLE` execution remains blocked until a
successor gate explicitly accepts the target domain and escalation policy.

The first routed `PS1-G8` planning bundle is
[Post-Stage-1 Side-Effect Planning Draft Spec](Post_Stage_1_Side_Effect_Planning_Draft_Spec.md).
It names `commit_fixture_document_candidate` as a fixture-local Document Ops
`COMMITTABLE` planning placeholder only. The placeholder is not an Execution IR
action enum, must not appear in task `allowed_actions`, and must not enter the
runtime execution path in this batch.

## Open Questions

- What is the minimum dependency graph representation for Stage 1?
- Should rollback policy be inline or referenced by policy ID?
- How should `COMPENSABLE` generalize beyond fixture-local Document Ops without
  executing irreversible external actions?
- What additional structured target types are needed after the G6 local
  interface is exercised beyond local tests?

## Related Documents

- [Stage 0 Boundary Lock](../00_manifest/Stage_0_Boundary_Lock.md)
- [Post-Stage-1 Runtime Scope Proposal](../00_manifest/Post_Stage_1_Runtime_Scope_Proposal.md)
- [Side-Effect Escalation Gate](../00_manifest/Side_Effect_Escalation_Gate.md)
- [Post-Stage-1 Side-Effect Planning Draft Spec](Post_Stage_1_Side_Effect_Planning_Draft_Spec.md)
- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
