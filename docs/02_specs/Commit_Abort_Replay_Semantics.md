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

## Open Questions

- What side-effect classes are allowed in the first MVP?
- What state hash granularity is required?
- How should compensation be represented for non-reversible actions beyond the
  Phase 4 fixture-local compensation record?

## Related Documents

- [Stage 0 Boundary Lock](../00_manifest/Stage_0_Boundary_Lock.md)
- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
