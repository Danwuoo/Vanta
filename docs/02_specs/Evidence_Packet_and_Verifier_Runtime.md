# Evidence Packet and Verifier Runtime

## Purpose

Define the structured evidence and verifier outputs needed to reduce invalid commits and make validation auditable.

## Scope

- Evidence Packet fields.
- Verifier inputs and outputs.
- Evidence sufficiency.
- False accept and false reject tracking.
- Provenance requirements.
- Requests for additional evidence.

## Non-goals

- Proving the Evidence Packet schema is optimal.
- Assuming model-generated explanations are faithful evidence.
- Replacing human review in high-risk cases.

## Inputs

- Pre-state summary.
- Execution step reference.
- Observation or tool output.
- Post-state summary.
- Constraints and policy requirements.
- Provenance metadata.

## Outputs

- Evidence Packet.
- Verifier output.
- Validity, confidence, risk, and calibration fields.
- Violated constraints.
- Required extra evidence.
- Credit hints for failure analysis.

## Key Concepts

- Evidence Packet is not an explanation; it is structured material for verification, audit, recovery, and regression.
- Provenance should come from external tools, environment diffs, source documents, or runtime metadata when possible.
- False accept is more dangerous than false reject for side-effectful actions.
- Verifier Runtime must not be reduced to final-answer-only judging.

## Open Questions

- Which evidence fields are mandatory for Stage 1?
- What calibration method should be used for verifier confidence?
- How should verifier disagreement be represented?

## Related Documents

- [Stage 0 Boundary Lock](../00_manifest/Stage_0_Boundary_Lock.md)
- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
