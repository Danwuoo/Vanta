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

## PS1-G6 Proposal-Only Evidence And Verifier Contract

[Post-Stage-1 Runtime Scope Proposal](../00_manifest/Post_Stage_1_Runtime_Scope_Proposal.md)
accepts `Document Ops Structured Edit Action Surface v0` for implementation
planning only. Future implementation must define action-specific Evidence
Packet requirements and deterministic verifier checks before the action names
enter runtime schemas.

| Candidate action | Required evidence | Required verifier checks |
| --- | --- | --- |
| `inspect_document_structure` | file hash, parsed structure summary, parse diagnostics, selected structure refs, source provenance | fixture-local path, no mutation, reproducible structure summary, diagnostics recorded |
| `validate_document_contract` | file hash, contract hash or contract ref, validation result, failure list, source and contract provenance | fixture-local source and contract refs, pass/fail result present, failures tied to source and contract versions, no mutation |
| `simulate_structured_edit` | before hash, after hash, candidate content, diff, operation summary, selector resolution, source provenance | source hash unchanged, diff or result summary present, selector resolution explicit, no source mutation |
| `apply_reversible_structured_edit` | before hash, after hash, diff, backup metadata, source hash after write, operation summary, selector resolution, source provenance | backup artifact exists, backup metadata exists, before/after hashes match evidence, write stays fixture-local, rollback metadata supports restore |

Ambiguous selectors, missing structured targets, absent contract provenance, or
source mutation during simulation must cause verifier rejection or an explicit
request for additional evidence before any commit path.

## PS1-G8 Side-Effect Evidence Boundary

[Side-Effect Escalation Gate](../00_manifest/Side_Effect_Escalation_Gate.md)
accepts `PS1-G8` for side-effect specification, schema impact review,
evaluation planning, and implementation planning only. It does not authorize
runtime execution of `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` actions.

Future evidence contracts for `COMMITTABLE` actions must include target
identity, pre-effect evidence, post-effect evidence, idempotency or duplicate
guards, approval records, verifier `accept`, and journal refs. `IRREVERSIBLE`
contracts must record risk, approval escalation, `rollback_unavailable`, and
compensation or reconciliation planning before any successor gate can consider
execution. `MEMORY_WRITE` contracts must include a memory candidate, source
provenance, retention and scope policy, staleness and conflict checks, deletion
or retraction path, verifier `accept`, and journal audit.

## Open Questions

- Which evidence fields are mandatory for Stage 1?
- What calibration method should be used for verifier confidence?
- How should verifier disagreement be represented?
- What minimum structured selector representation should be required before
  `PS1-G6` candidate actions become schema-backed runtime interfaces?

## Related Documents

- [Stage 0 Boundary Lock](../00_manifest/Stage_0_Boundary_Lock.md)
- [Post-Stage-1 Runtime Scope Proposal](../00_manifest/Post_Stage_1_Runtime_Scope_Proposal.md)
- [Side-Effect Escalation Gate](../00_manifest/Side_Effect_Escalation_Gate.md)
- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
