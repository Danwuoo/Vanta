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

## Stage 1 Fixture Set

The first fixture set is prepared under
`docs/04_experiments/fixtures/document_ops/` and mirrored under
`test/fixtures/document_ops/`.

Initial fixtures:

- `docops_read_traceability_001`
- `docops_detect_terms_001`
- `docops_simulate_patch_001`
- `docops_reversible_edit_001`
- `docops_action_not_allowed_001`
- `docops_path_escape_001`
- `docops_wrong_diff_001`

These fixtures include positive and negative Stage 1 acceptance cases. They are
now the seven-fixture local smoke set used by Experiments 001, 002, and 003.
They supported the minimal loop, verifier hardening, and journal/replay local
smoke closures.

These fixtures are not a broad benchmark. They provide a small controlled
Document Ops spine for local smoke evidence and regression checks only.

## Status

Fixture set prepared with deterministic acceptance recipes and exercised by:

- Experiment 001 minimal loop local smoke closure on 2026-05-03.
- Experiment 002 verifier hardening local smoke closure on 2026-05-04.
- Experiment 003 journal/replay local smoke closure on 2026-05-04.

The current status is local smoke support for Stage 1, not broad benchmark
coverage or statistical validation.

## Related Documents

- [Benchmark Task Format](Benchmark_Task_Format.md)
- [Metrics Definition](../05_evaluation/Metrics_Definition.md)
- [Stage 1 Experiment 001 Closure](../00_manifest/Stage_1_Experiment_001_Closure.md)
- [Stage 1 Experiment 002 Closure](../00_manifest/Stage_1_Experiment_002_Closure.md)
- [Stage 1 Experiment 003 Closure](../00_manifest/Stage_1_Experiment_003_Closure.md)
