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

## Stage 1 Fixture Sets

Document Ops fixtures are prepared under
`docs/04_experiments/fixtures/document_ops/` and mirrored under
`test/fixtures/document_ops/`.

### Initial Seven-Fixture Smoke Set

The initial local smoke set contains:

- `docops_read_traceability_001`
- `docops_detect_terms_001`
- `docops_simulate_patch_001`
- `docops_reversible_edit_001`
- `docops_action_not_allowed_001`
- `docops_path_escape_001`
- `docops_wrong_diff_001`

These fixtures include positive and negative Stage 1 acceptance cases. They are
the historical seven-fixture local smoke set used by Experiments 001, 002, and
003. They supported the minimal loop, verifier hardening, and journal/replay
local smoke closures.

The initial seven-fixture smoke set is not a broad benchmark. It provides a small
controlled Document Ops spine for local smoke evidence and regression checks
only.

### Expanded Document Ops Fixture Set

The expanded fixture set begins after the Experiment 001, 002, and 003 local
smoke closures. Its first purpose is not to increase sample size in isolation,
but to add failure and recovery-relevant shapes needed before Phase 4 Targeted
Recovery:

- Multi-step commit cases.
- Rollback failure cases.
- Audit gap cases.
- Compensable action cases.

Expanded fixtures may change current fixture counts, review item counts, and
invalid action rates. Tests and runners should compute those values from fixture
directories and acceptance metadata rather than treating the initial seven-item
smoke set as a fixed constant.

Current expanded fixtures:

- `docops_multistep_commit_001`: three-step read/simulate/diff commit path for
  journal, evidence, verifier, and replay coverage without source mutation.

## Status

Fixture set prepared with deterministic acceptance recipes and exercised by:

- Experiment 001 minimal loop local smoke closure on 2026-05-03.
- Experiment 002 verifier hardening local smoke closure on 2026-05-04.
- Experiment 003 journal/replay local smoke closure on 2026-05-04.

The current status is local smoke support for Stage 1 plus preflight preparation
for expanded fixture coverage. This is not broad benchmark coverage or
statistical validation.

## Related Documents

- [Benchmark Task Format](Benchmark_Task_Format.md)
- [Metrics Definition](../05_evaluation/Metrics_Definition.md)
- [Stage 1 Experiment 001 Closure](../00_manifest/Stage_1_Experiment_001_Closure.md)
- [Stage 1 Experiment 002 Closure](../00_manifest/Stage_1_Experiment_002_Closure.md)
- [Stage 1 Experiment 003 Closure](../00_manifest/Stage_1_Experiment_003_Closure.md)
