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
- Status: `Closed: local smoke completed` on 2026-05-06.
- Entry need satisfied for controlled Document Ops recovery fixtures:
  multi-step commit, rollback failure, audit gap, and compensable action cases.
- Remaining work: expand beyond the three controlled recovery fixtures, add
  ambiguous or multi-label failures, add human or secondary labels, and avoid
  broad H4 validation claims until larger measured ablations exist.

## Phase 5: Context OS Candidate

- Implement `Working Set Compiler v0` only, not full Context OS.
- Compare bounded raw trace against schema-valid, reference-backed
  `WorkingSet` artifacts on five Document Ops long-context fixtures.
- Keep model, prompt budget, response budget, latency controls, and OpenClaw
  local harness interface fixed for Experiment 005 local smoke.
- Do not add memory writes, full memory dumps, learned retrieval, or raw tool
  log dumps.
- Status: `Closed: local smoke completed` on 2026-05-07.
- Remaining work: expand beyond five controlled Document Ops long-context
  fixtures, add human or secondary omission/relevance labels, and avoid broad H3
  or full Context OS validation claims until larger measured ablations exist.

## Post-Stage-1 Gate Tracking

Post-Stage-1 advancement is governed by
[Post-Stage-1 Advancement Gate](../00_manifest/Post_Stage_1_Advancement_Gate.md).

- Milestone gates before advancing phases are tracked by `PS1-G1` through
  `PS1-G8`.
- Broader experiment sample size is tracked by `PS1-G1`.
