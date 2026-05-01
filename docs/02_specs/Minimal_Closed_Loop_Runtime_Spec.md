# Minimal Closed Loop Runtime Spec

## Purpose

Define the MVP runtime loop that turns state into action, action into evidence, evidence into verification, and verification into commit or abort.

## Scope

- Canonical state intake and update.
- Candidate plan/action proposal.
- Compilation into Execution IR.
- Evidence Packet construction.
- Verifier Runtime invocation.
- Commit or abort decision.
- Episode Journal logging.

## Non-goals

- Full Context OS optimization.
- Long-term memory training.
- Irreversible external side effects.
- Production deployment.
- Claims that the architecture is empirically validated.

## Inputs

- User task or environment event.
- Current canonical state.
- Runtime constraints.
- Available action schemas.
- Prior episode context, if any.

## Outputs

- Updated canonical state.
- Execution steps.
- Evidence packets.
- Verifier outputs.
- Commit or abort status.
- Episode journal entry.

## Key Concepts

- The minimal loop is `state -> plan -> action -> evidence -> verify -> commit / abort`.
- Every non-trivial action must produce evidence before commit.
- The verifier may abstain or request additional evidence.
- Failed steps should preserve enough journal data for later recovery analysis.

## Open Questions

- What is the first controlled environment for MVP tasks?
- What verifier implementation is acceptable for the first prototype?
- What minimum evidence fields are required for a commit?

## Related Theory Documents

- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
