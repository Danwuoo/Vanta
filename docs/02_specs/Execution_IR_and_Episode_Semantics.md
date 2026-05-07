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

## Open Questions

- What is the minimum dependency graph representation for Stage 1?
- Should rollback policy be inline or referenced by policy ID?
- How should `COMPENSABLE` generalize beyond fixture-local Document Ops without
  executing irreversible external actions?

## Related Documents

- [Stage 0 Boundary Lock](../00_manifest/Stage_0_Boundary_Lock.md)
- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
