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
- Document Ops fixture mirrors under `docs/` and `test/` remain byte-for-byte
  synchronized.
- Stage 1 commit controller rejects non-`accept` verifier decisions and
  disallowed side-effect classes.
- Runtime integration tests cover positive commit paths, negative rejection
  paths, rollback metadata, baseline invalid-action recording, mock LLM
  structured output, mock OpenClaw agent payload parsing, replay consistency,
  and compact experiment run output.
- Experiment 002 tests cover mock OpenClaw verifier output parsing, JSON fence
  parsing, parse-failure-to-abstain normalization, fixture oracle review item
  generation, strict false-reject policy, and compact three-arm metrics.
- Experiment 004 tests cover OpenClaw recovery output parsing, JSON fence
  parsing, malformed-output normalization to `no_recovery`, rollback-failure
  recovery, audit-gap repair, compensation record creation, and matched-budget
  blind retry metrics.
- Experiment 005 tests cover schema-valid `WorkingSet` generation, budget
  overflow notes, provenance completeness, rejection of raw tool log / full
  memory dump / memory write refs, bounded raw trace truncation, OpenClaw
  context planner JSON parsing, mock experiment metrics, and fixture mirror
  synchronization.

## Open Questions

- How should non-deterministic tool outputs be simulated?
- What is the minimum replay fidelity requirement for MVP?
