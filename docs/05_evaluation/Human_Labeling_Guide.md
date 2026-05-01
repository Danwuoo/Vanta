# Human Labeling Guide

## Purpose

Define initial human labeling responsibilities for Vanta experiments.

## Labeling Targets

- Task success.
- Action validity.
- Evidence sufficiency.
- Failure class.
- Commit integrity.
- Audit completeness.

## General Rules

- Label the observed artifact, not the intended design.
- Do not infer missing provenance.
- Mark ambiguous cases as `needs_review`.
- Separate correctness from auditability.
- Record the source document, benchmark task, and criteria version used for each label.

## Required Outputs

- Label value.
- Confidence.
- Rationale.
- Referenced evidence packet or episode step.
- Reviewer identity or anonymized reviewer ID.

## Open Questions

- Should each high-risk action receive two independent labels?
- What is the escalation path for label disagreement?
