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
- Stage 0 boundary locks constrain this loop: state, execution trace, evidence, verifier output, journal, memory, and rollback semantics remain separate artifacts.

## Stage 1 Locked Answers

- Stage 1 local smoke status: `Closed: local smoke completed`.
- First controlled environment: local Document Ops fixtures.
- Verifier implementation: deterministic Verifier v0 using JSON Schema validation,
  side-effect-class rules, fixture-specific acceptance checks, required evidence
  checks, and provenance completeness checks.
- Minimum commit evidence: `pre_state_hash`, `post_state_hash`, `step_id`,
  `action_ref`, normalized `observation`, `post_state_summary`, `provenance`,
  and `runtime_context`. Simulated or reversible edits must include a diff or
  result summary inside the normalized observation.
- Allowed side-effect classes: `READ_ONLY`, `SIMULATED`, and `REVERSIBLE`.
- Disallowed side-effect classes: `COMMITTABLE`, `IRREVERSIBLE`, and
  `MEMORY_WRITE` for the first Stage 1 runtime.

## Post-Stage-1 Deferred Questions

- What metric thresholds define broader MVP acceptance beyond the Stage 1 local
  smoke gate?
- What sample size is required before Experiment 001 can support broader
  comparison?
- Should the OpenClaw harness baseline remain local-only, be replaced by direct
  OpenAI Responses, or be reported alongside direct Responses?

## Related Documents

- [Stage 0 Boundary Lock](../00_manifest/Stage_0_Boundary_Lock.md)
- [Stage 1 MVP Entry Gate](../00_manifest/Stage_1_MVP_Entry_Gate.md)
- [Stage 1 Experiment 001 Closure](../00_manifest/Stage_1_Experiment_001_Closure.md)
- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
