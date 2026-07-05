# Experiment Results

## Purpose

This directory is the navigation entry for Vanta experiment result artifacts.
It records where result families live and how to read their status without
moving historical provenance directories.

Result directories are evidence and provenance records. They are not theory
documents, not implementation orders, and not validation claims unless a
separate evaluation report and manifest closure say so.

## Result Families

| Family | Purpose | Status | Measured | Planning-only |
| --- | --- | --- | --- | --- |
| `experiment_001/` | Stage 1 minimal closed-loop local smoke run artifacts. | Historical Stage 1 local smoke family. The closure document, not this index, identifies the accepted local smoke result. | Yes, for completed compact run artifacts. Historical attempts remain provenance. | No |
| `experiment_002/` | Stage 1 evidence/verifier hardening local smoke run artifacts. | Historical Stage 1 local smoke family with completed and partial historical attempts. The closure document identifies the accepted local smoke result. | Yes, for completed compact run artifacts; partial directories remain provenance. | No |
| `experiment_003/` | Stage 1 commit, journal, and replay local smoke run artifacts. | Historical Stage 1 local smoke family. | Yes, for the completed local smoke result. | No |
| `experiment_004/` | Stage 1 targeted recovery local smoke run artifacts. | Historical Stage 1 local smoke family. | Yes, for the completed local smoke result. | No |
| `experiment_005/` | Stage 1 Working Set Compiler v0 local smoke run artifacts. | Historical Stage 1 local smoke family. | Yes, for the completed local smoke result. | No |
| `post_stage_1_larger_sample/` | Lane A larger controlled Document Ops sample run artifacts for `PS1-LA-SAMPLE-002`. | Active Lane A result family. It contains failed, threshold-passing candidate, superseded, timeout or partial, and closure-accepted provenance. | Yes, for completed run directories with `run.json`, `summary.md`, and `fixture_inventory.md`; not every directory is accepted. | No |
| `side_effect_planning/` | PS1-G8 side-effect planning artifact scaffolds. | Planning artifact family only. Current artifacts materialize planning contracts and do not execute side-effect runtime actions. | No runtime execution measurement. | Yes |

## Accepted Closure Boundary

`post_stage_1_larger_sample/20260601_113121/` is accepted by manifest closure
only as the named threshold-governed Document Ops Lane A sample. Its runner
threshold status is `pass_acceptance_candidate`; the manifest closure upgrades
that named result to `accepted_by_closure`.

That acceptance does not validate H1-H5, authorize full Context OS, approve
production readiness, authorize memory writes, authorize irreversible effects,
authorize runtime execution of side-effect planning surfaces, or promote
OpenClaw local harness arms to pure model-only baselines.

## Provenance Retention

Historical, failed, superseded, timeout, and partial run directories are
provenance. They should not be deleted, renamed, moved, or rewritten to make the
tree look cleaner. Later reports may supersede their interpretation, but the
original directories remain useful for audit, regression, and source-to-report
traceability.

When a run directory contains raw logs, wrapper output, ignored JSON, or
scratch artifacts, preserve already-tracked provenance in place and follow the
artifact retention policy in
[Repository Structure](../../06_engineering/Repository_Structure.md). New
summary or closure claims must be made through evaluation or manifest documents,
not by mutating historical run artifacts.

## Related Documents

- [Document Ops Benchmark](../Document_Ops_Benchmark.md)
- [Post-Stage-1 Larger Sample G6 Successor Plan](../Post_Stage_1_Larger_Sample_G6_Successor_Plan.md)
- [Post-Stage-1 Side-Effect Evaluation Plan](../Post_Stage_1_Side_Effect_Evaluation_Plan.md)
- [Post-Stage-1 Lane A 20260601_113121 Run Report](../../05_evaluation/Post_Stage_1_Lane_A_20260601_113121_Run_Report.md)
- [Post-Stage-1 Lane A 20260601_113121 Closure](../../00_manifest/Post_Stage_1_Lane_A_20260601_113121_Closure.md)
