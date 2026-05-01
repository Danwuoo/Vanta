# Experiment 002: Evidence Verifier

## Research question

Does structured Evidence Packet input improve verifier reliability compared with final-answer judging or raw trace judging?

## Hypothesis tested

H2: Evidence Packet can significantly improve verifier reliability.

## Baseline

Verifier sees only final answer or unstructured execution trace.

## Treatment

Verifier consumes structured Evidence Packet fields including pre-state, action reference, observation, post-state, constraints, and provenance.

## Metrics

- `verifier_false_accept_rate`
- `verifier_false_reject_rate`
- `evidence_sufficiency_score`
- Calibration metrics to be defined before execution.

## Required logs

- Evidence packets.
- Verifier decisions.
- Human accept/reject labels.
- Provenance source records.

## Success criteria

- Treatment reduces false accept rate under matched task distribution.
- Treatment does not create an unacceptable false reject increase.
- Evidence sufficiency labels correlate with verifier decisions.

## Failure criteria

- Evidence Packet increases false confidence.
- Verifier accepts invalid actions because model-generated explanations are treated as evidence.
- Provenance is missing or not externally grounded.

## Status

Not yet run.
