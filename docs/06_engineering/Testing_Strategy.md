# Testing Strategy

## Purpose

Define how implementation should be tested once runtime code exists.

## Test Layers

- Schema validation tests for all runtime artifacts.
- Unit tests for state transitions, Execution IR compilation, evidence construction, and journal writes.
- Integration tests for `state -> plan -> action -> evidence -> verify -> commit / abort`.
- Replay tests using controlled fixtures.
- Regression tests for invalid actions, false accepts, audit gaps, and rollback failures.

## Required Fixtures

- Successful minimal task.
- Invalid action task.
- Missing evidence task.
- Commit then replay task.
- Rollback or abort task.
- Ambiguous failure-label task.

## Acceptance Criteria

- Runtime artifacts validate against schemas.
- Episode journal contains required audit fields.
- Verifier cannot commit missing-evidence actions in controlled tests.
- Replay succeeds in deterministic fixtures.

## Open Questions

- Which tests should block commits?
- How should non-deterministic tool outputs be simulated?
- What is the minimum replay fidelity requirement for MVP?
