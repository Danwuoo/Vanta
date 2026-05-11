# Commit Abort Replay Semantics

## Purpose

Define the semantics for committing, aborting, rolling back, reconciling, and replaying runtime episodes.

## Scope

- Commit status transitions.
- Abort behavior.
- Rollback and compensation notes.
- Replay-safe logging requirements.
- Runtime manifest references.
- Audit completeness.

## Non-goals

- Treating all external side effects as reversible.
- Implementing distributed transactions in the MVP.
- Hiding unsafe actions behind prompt-only checks.

## Inputs

- Execution step.
- Evidence Packet.
- Verifier output.
- Side-effect class.
- Runtime manifest.
- State hash.

## Outputs

- Commit, abort, rollback, or reconciliation status.
- Episode Journal update.
- Replay record.
- Audit artifact.

## Key Concepts

- `commit` applies a verified change to the accepted runtime state.
- `abort` stops an uncommitted action path.
- `rollback` applies only to reversible changes.
- `reconcile` or compensation is required when external effects cannot be strictly rolled back.
- Phase 4 fixture-local compensable actions must record compensation treatment
  rather than claiming strict rollback.
- `replay` requires enough versioned runtime and tool metadata to reconstruct the episode.
- Episode Journal records audit and replay data; it is not durable memory.

## PS1-G6 Proposal-Only Commit And Replay Contract

[Post-Stage-1 Runtime Scope Proposal](../00_manifest/Post_Stage_1_Runtime_Scope_Proposal.md)
accepts `Document Ops Structured Edit Action Surface v0` for implementation
planning only. Future implementation must preserve the existing commit,
rollback, and replay boundaries.

| Candidate action class | Commit behavior | Abort or reject behavior | Replay requirement |
| --- | --- | --- | --- |
| `READ_ONLY` structured inspection and contract validation | May update accepted runtime state only with verified observation summaries and audit refs; source files remain unchanged. | Reject or request evidence when source, contract, parse, or provenance evidence is missing. | Replay must reproduce the same fixture-local read or validation observation from versioned source and contract refs. |
| `SIMULATED` structured edit | May commit only the verified simulated observation, candidate content reference, diff, and state event; source files remain unchanged. | Reject if simulation mutates source, lacks diff/candidate content, or has ambiguous selector resolution. | Replay must reproduce the candidate content, diff, before/after hashes, and unchanged source hash. |
| `REVERSIBLE` structured edit | May commit only after verifier `accept`, required Evidence Packet fields, fixture-local write, and backup metadata are present. | Abort or reject when backup metadata, hash agreement, fixture-local path safety, or verifier accept is missing. | Replay must reconstruct the edit path and confirm backup metadata is sufficient for fixture-local restore. |

`PS1-G6` does not expand `COMPENSABLE`, `COMMITTABLE`, `IRREVERSIBLE`, or
`MEMORY_WRITE` behavior. Rollback must be recorded only for reversible
fixture-local edits with concrete backup metadata.

## PS1-G8 Side-Effect Commit Boundary

[Side-Effect Escalation Gate](../00_manifest/Side_Effect_Escalation_Gate.md)
accepts `PS1-G8` for side-effect specification, schema impact review,
evaluation planning, and implementation planning only. It does not authorize
runtime execution of `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` actions.

Future `COMMITTABLE` commit paths must record approval, verifier `accept`,
pre/post effect evidence, idempotency or duplicate guards, and either rollback
availability or compensation declaration before commit. `IRREVERSIBLE` paths
must remain blocked until a successor gate defines explicit escalation,
`rollback_unavailable`, risk records, compensation or reconciliation plans, and
post-action audit requirements. `MEMORY_WRITE` paths must record the memory
candidate, provenance, retention and scope, deletion or retraction path,
approval policy, verifier `accept`, and Episode Journal audit refs; memory
append is not learning.

## Open Questions

- Which post-`PS1-G8` side-effect domain should be specified first?
- What state hash granularity is required?
- How should compensation be represented for non-reversible actions beyond the
  Phase 4 fixture-local compensation record?
- What replay fidelity threshold is required before `PS1-G6` structured-edit
  actions can be used in measured runs?

## Related Documents

- [Stage 0 Boundary Lock](../00_manifest/Stage_0_Boundary_Lock.md)
- [Post-Stage-1 Runtime Scope Proposal](../00_manifest/Post_Stage_1_Runtime_Scope_Proposal.md)
- [Side-Effect Escalation Gate](../00_manifest/Side_Effect_Escalation_Gate.md)
- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
