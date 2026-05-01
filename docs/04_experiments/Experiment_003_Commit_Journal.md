# Experiment 003: Commit Journal

## Research question

Does Episode Journal governance improve commit integrity, replay consistency, and audit completeness?

## Hypothesis tested

H5: Episode governance is the core foundation of agent safety.

## Baseline

Agent records only tool traces and final outputs.

## Treatment

Agent records Episode Journal entries with state hashes, action identity, evidence identity, verifier result, commit status, rollback status, runtime/tool provenance, and memory write effects.

## Metrics

- `commit_integrity_score`
- `replay_consistency`
- `audit_completeness`
- `invalid_action_rate`

## Required logs

- Episode journal.
- Runtime manifest.
- Tool/environment version records.
- Evidence packets.
- Verifier outputs.

## Success criteria

- Committed changes can be audited from logs.
- Replay produces consistent accepted state in controlled tasks.
- Invalid or unsafe commits are reduced.

## Failure criteria

- Journal overhead prevents task completion.
- Replay is impossible due to missing runtime or tool metadata.
- Rollback is claimed for actions that are only compensable or irreversible.

## Status

Not yet run.
