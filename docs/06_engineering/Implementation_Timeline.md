# Implementation Timeline

## Purpose

Define a staged engineering path that follows the research priorities and avoids building the full architecture before measurement.

## Phase 0: Documentation And Contracts

- Complete source translations.
- Freeze schema skeletons.
- Define metric and label guides.
- Select first benchmark domain.

## Phase 1: Minimal Closed Loop

- Implement state manager, Execution IR compiler, evidence builder, verifier stub, commit/abort controller, and episode journal.
- Run Experiment 001 on controlled tasks.
- Status: `Closed: local smoke completed` on 2026-05-03.

## Phase 2: Evidence And Verifier

- Implement structured verifier inputs.
- Run Experiment 002 local smoke.
- Status: `Closed: local smoke completed` on 2026-05-04.
- Remaining work: human labels, larger samples, and broader false accept / false
  reject analysis.

## Phase 3: Commit Journal And Replay

- Add replay checks and audit completeness checks.
- Run Experiment 003 local smoke.
- Status: `Closed: local smoke completed` on 2026-05-04.
- Remaining work: expanded fixture coverage, secondary audit labels, and
  multi-step / compensable action cases.

## Phase 4: Targeted Recovery

- Add Failure Taxonomy labels and basic recovery policies.
- Run compute-matched ablation against blind retry.
- Status: next phase, not yet started.
- Entry need: expanded Document Ops fixtures for multi-step commit, rollback
  failure, audit gap, and compensable action cases.

## Phase 5: Context OS Candidate

- Add working set compiler only after earlier phases produce stable logs and metrics.

## Post-Stage-1 Open Questions

- What milestone gates are required before advancing phases?
- What sample size is feasible for broader experiments?
