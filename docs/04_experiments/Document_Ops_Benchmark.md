# Document Ops Benchmark

## Purpose

Define a candidate controlled benchmark domain for evaluating Vanta without irreversible external side effects.

## Scope

Document operations tasks should require multi-step reasoning, source tracking, action execution, evidence collection, verification, and audit.

## Candidate Task Families

- Translate a source document while preserving structure.
- Refactor a document tree without deleting originals.
- Extract traceability links across multiple documents.
- Apply structured edits and verify no source content was lost.
- Detect inconsistent terminology across specifications.

## Required Logs

- Benchmark task record.
- Execution steps.
- Evidence packets.
- Verifier outputs.
- Episode journal.
- Human labels, where needed.

## Success Criteria

- Task output satisfies the task-specific acceptance criteria.
- No source document is modified unless explicitly required.
- Evidence is sufficient to audit important transformations.
- Replay metadata is complete enough for postmortem review.

## Failure Criteria

- Source content is omitted or distorted.
- Unsupported validation claims are introduced.
- Required provenance is missing.
- The runtime commits an invalid or unsafe action.

## Status

Not yet run.

## Related Documents

- [Benchmark Task Format](Benchmark_Task_Format.md)
- [Metrics Definition](../05_evaluation/Metrics_Definition.md)
