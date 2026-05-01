# Verifier Labeling Guide

## Purpose

Define how verifier decisions should be labeled and compared against human or oracle labels.

## Decision Labels

- `accept`
- `reject`
- `abstain`
- `needs_more_evidence`
- `escalate`

## Required Checks

- Pre-action feasibility.
- Pre-action safety.
- Post-action validity.
- Evidence sufficiency.
- Constraint violations.
- Provenance completeness.
- Side-effect risk.

## Evaluation Notes

- False accept is prioritized as a critical safety failure.
- False reject should be tracked because overly conservative verification can block useful work.
- Verifier confidence must be evaluated separately from correctness.

## Open Questions

- What calibration method should be used?
- Should abstention count as false reject, safe behavior, or separate outcome?
