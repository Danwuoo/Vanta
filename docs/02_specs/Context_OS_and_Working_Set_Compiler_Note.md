# Context OS and Working Set Compiler Note

## Purpose

Define the Stage 0 boundary for Context OS and the minimum Working Set Compiler
contract without pulling full Context OS optimization into Stage 1.

## Status

Stage 0 boundary note. This is not a full Context OS implementation spec and not
an empirical claim that working-set compilation improves performance.

## Scope

- Working set artifact boundaries.
- Context selection references.
- Provenance requirements.
- Omitted-context notes.
- Relationship to canonical state, evidence, memory, and recovery context.

## Non-goals

- Full long-term memory governance.
- Retrieval, ranking, or compression algorithm design.
- Training on runtime feedback.
- Treating a larger context window as equivalent to Context OS.
- Treating raw tool logs or full memory dumps as a working set.

## Inputs

- Active goal or task reference.
- Current canonical state reference.
- Candidate memory references.
- Evidence Packet references.
- Constraint and policy references.
- Recovery context references, when relevant.
- Token, latency, and provenance constraints.

## Outputs

- `WorkingSet` record.
- Selected references to canonical state, memory, evidence, constraints, and
  recovery context.
- Selection policy and selection rationale.
- Token budget metadata.
- Provenance for included context.
- Notes about important omitted context.

## Key Concepts

- Context OS compiles a working set; it does not store all memory or replace
  native long-context capability.
- Working set content should be reference-backed and budget-aware.
- Omitted context is part of the audit surface because omissions can cause
  representation, memory, abstraction, or evaluation failures.
- Working set selection may inform verifier, recovery, and evaluation, but it is
  not itself proof that the selected context is sufficient.
- Stage 1 may reference `WorkingSet` records, but full Context OS optimization is
  deferred until earlier loop, evidence, verifier, and journal phases produce
  stable logs and metrics.

## Minimum Data Contract

The minimum data contract is defined by
[`working_set.schema.json`](../03_schemas/working_set.schema.json). The schema
uses references and provenance instead of raw context dumps, raw tool logs, or
full memory dumps.

## Open Questions

- What selection policy is sufficient for the first measured Context OS
  candidate?
- What label scale should measure context omission or provenance loss?
- Which failures should trigger working-set recompilation rather than verifier
  rejection or targeted recovery?

## Related Documents

- [Stage 0 Boundary Lock](../00_manifest/Stage_0_Boundary_Lock.md)
- [Project Manifest](../00_manifest/Project_Manifest.md)
- [Research Questions](../00_manifest/Research_Questions.md)
- [Ablation Plan](../04_experiments/Ablation_Plan.md)
- [Metrics Definition](../05_evaluation/Metrics_Definition.md)
