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

## PS1-G6 Proposal-Only Action Surface

[Post-Stage-1 Runtime Scope Proposal](../00_manifest/Post_Stage_1_Runtime_Scope_Proposal.md)
accepts `Document Ops Structured Edit Action Surface v0` for implementation
planning only. The proposed candidate actions are not schema-backed runtime
interfaces until a later implementation batch updates schemas, code, fixtures,
and tests together.

| Candidate action | Side-effect class | Execution IR requirement |
| --- | --- | --- |
| `inspect_document_structure` | `READ_ONLY` | Must target a fixture-local document path and record a parsed structure summary without mutation. |
| `validate_document_contract` | `READ_ONLY` | Must target a fixture-local document path plus a fixture-local or inline contract and record pass/fail details without mutation. |
| `simulate_structured_edit` | `SIMULATED` | Must identify a structured target, produce candidate content, diff, before/after hashes, and keep the source hash unchanged. |
| `apply_reversible_structured_edit` | `REVERSIBLE` | Must identify a structured target, write only inside the fixture workspace, use `fixture_backup_restore`, and include backup metadata. |

The candidate action surface must continue to use task action allowlists,
side-effect allowlists, workspace path guards, verifier requirements, and
Episode Journal references. `COMPENSABLE` remains limited to the existing Phase
4 fixture-local receipt treatment and is not expanded by `PS1-G6`.

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

## Open Questions

- What is the minimum dependency graph representation for Stage 1?
- Should rollback policy be inline or referenced by policy ID?
- How should `COMPENSABLE` generalize beyond fixture-local Document Ops without
  executing irreversible external actions?
- Which `PS1-G6` candidate actions should be promoted into schema-backed
  runtime interfaces in the later implementation batch?

## Related Documents

- [Stage 0 Boundary Lock](../00_manifest/Stage_0_Boundary_Lock.md)
- [Post-Stage-1 Runtime Scope Proposal](../00_manifest/Post_Stage_1_Runtime_Scope_Proposal.md)
- [Side-Effect Escalation Gate](../00_manifest/Side_Effect_Escalation_Gate.md)
- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
