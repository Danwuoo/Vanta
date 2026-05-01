# Experiment 001: Minimal Loop

## Research question

Does a minimal closed loop improve task success and reduce invalid actions compared with a baseline function-calling agent?

## Hypothesis tested

H1: Reasoning-to-action fidelity is the core bottleneck of agent capability.

## Baseline

ReAct or traditional function-calling agent with no explicit Execution IR, Evidence Packet, or Episode Journal.

## Treatment

Runtime with canonical state, Execution IR, Evidence Packet, Verifier Runtime, and commit/abort logging for reversible or simulated actions.

## Metrics

- `task_success_rate`
- `invalid_action_rate`
- `evidence_sufficiency_score`
- `commit_integrity_score`

## Required logs

- Canonical state snapshots.
- Execution steps.
- Evidence packets.
- Verifier outputs.
- Episode journal.

## Success criteria

- Treatment improves task success or reduces invalid action rate without increasing unsupported commits.
- Treatment produces complete logs for audit.

## Failure criteria

- Treatment only improves task success by hiding invalid actions.
- Required logs are missing.
- Source or environment state changes cannot be explained from the journal.

## Status

Not yet run.
