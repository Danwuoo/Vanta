# Post-Stage-1 Side-Effect Schema Impact Review

## Purpose

Review whether the current schema layer is sufficient for the first `PS1-G8`
side-effect planning bundle.

This review covers the fixture-local Document Ops `COMMITTABLE` planning surface
defined by
[Post-Stage-1 Side-Effect Planning Draft Spec](../02_specs/Post_Stage_1_Side_Effect_Planning_Draft_Spec.md).
It is a planning document and does not change any JSON schema file.

## Status

Review status: `Side-effect planning draft`.

Planning surface ID: `PS1-LC-SIDEFX-COMMITTABLE-DOCOPS-001`.

Gate policy version: `PS1-LC-SIDEFX-GATE-001`.

Schema decision for this batch: no schema changes.

Implementation status: `Not authorized`.

Runtime execution status: `Not authorized`.

Run status: `Not yet run`.

## Conclusion

The current schemas are sufficient to route this batch as a planning artifact
because no runtime action, fixture, run artifact, approval record, or executed
`COMMITTABLE` step is produced.

The current schemas are not sufficient for executable `COMMITTABLE` Document Ops
runtime behavior. They already contain a `COMMITTABLE` side-effect enum in some
places, but they do not define a concrete committable action type, structured
payload, typed approval record, idempotency guard, duplicate-commit guard, or
typed rollback or compensation contract.

Therefore this batch must remain a no-change schema impact review with explicit
planning placeholders.

## Current Schema Coverage

| Schema | Current coverage | Impact decision |
| --- | --- | --- |
| `execution_step.schema.json` | `side_effect_class` includes `COMMITTABLE`, and generic fields exist for preconditions, postconditions, verifier requirements, and rollback policy. | Sufficient to discuss the class conceptually, but not sufficient for an executable committable action because `action_type` lacks `commit_fixture_document_candidate` and no payload contract exists. |
| `planner_action_sequence.schema.json` | Restricts planner actions to the current Stage 1 and G6 action set. | Correctly blocks a new committable action. Do not add a planning placeholder to the runtime planner schema in this batch. |
| `benchmark_task.schema.json` | `side_effect_classes` includes `COMMITTABLE`, while `allowed_actions` remains limited to current action names. | Sufficient to show future task intent, but not sufficient for runnable fixtures because no allowed committable action exists. |
| `evidence_packet.schema.json` | Allows generic structured `observation`, `provenance`, and `runtime_context` objects. | Sufficient for planning prose only; not enough to enforce required pre-effect and post-effect committable evidence. |
| `verifier_output.schema.json` | Supports `accept`, `reject`, `abstain`, and `request_evidence`, with `side_effect_safety` and `policy_constraints` scopes. | Sufficient for planning the verifier boundary; not enough to enforce approval correctness or duplicate-guard completeness. |
| `episode_journal.schema.json` | Supports commit status, rollback status, and memory-write audit refs. | Sufficient for audit-boundary discussion; not enough to type approval refs, idempotency keys, compensation plans, or post-effect manifest refs. |
| `experiment_run.schema.json` | Captures measured run-level artifacts and metrics. | No change. This planning batch has no measured run. |
| `eval_result.schema.json` | Captures evaluation outputs and labels when reported. | No change. Approval-boundary labels are not runtime approvals and are not defined in this batch. |

## Planning Placeholders

These fields are required by the planning spec but are not current schema
properties:

| Placeholder | Current representation | Future schema need |
| --- | --- | --- |
| `commit_fixture_document_candidate` | Markdown placeholder only. | New action enum and payload contract before execution. |
| `target_identity` | Planning table field. | Structured object binding fixture workspace, source ref, candidate ref, target path, and hashes. |
| `approval_policy_ref` | Planning table field. | Versioned approval policy reference. |
| `approval_record_requirement` | Planning table field. | Typed approval record or journal ref. |
| `idempotency_key` | Planning table field. | Required duplicate guard field before commit. |
| `duplicate_guard` | Planning table field. | Structured rule for rejecting repeated or conflicting commits. |
| `pre_effect_evidence_requirements` | Planning table field. | Required evidence fields or action-specific evidence contract. |
| `post_effect_evidence_requirements` | Planning table field. | Required post-effect evidence fields after authorized execution. |
| `rollback_or_compensation_statement` | Planning table field. | Typed enum or policy ref distinguishing strict rollback from compensation. |
| `compensation_plan_ref` | Planning table field when compensation is used. | Typed compensation or reconciliation record. |

These placeholders must not be smuggled into runtime artifacts as untyped
side-channel fields.

## No-Change Decisions

| Area | Decision |
| --- | --- |
| Action enums | Do not add `commit_fixture_document_candidate` or any other `COMMITTABLE` action name. |
| Runtime side-effect enablement | Do not change runtime allowlists or task allowlists. |
| Approval schema | Do not add `approval_record.schema.json` in this batch. |
| Evidence schema | Do not add committable-specific required evidence fields yet. |
| Journal schema | Do not add approval, idempotency, or compensation fields yet. |
| Benchmark fixtures | Do not add runnable `COMMITTABLE` fixtures in this batch. |
| Memory writes | Do not add or enable memory-write fields beyond the existing audit boundary. |
| Irreversible effects | Do not add irreversible-effect schema behavior. |

## Future Schema Candidates

A later implementation-candidate batch may consider these schema changes only
after an accepted successor spec requires them.

| Candidate | Possible trigger | Current status |
| --- | --- | --- |
| `committable_document_action` payload contract | A later spec accepts executable fixture-local `COMMITTABLE` Document Ops behavior. | Future question, not authorized. |
| `approval_record.schema.json` | A later approval policy requires machine-readable approval records before commit. | Future question, not authorized. |
| `side_effect_policy.schema.json` | Multiple side-effect classes need shared policy versioning and target-boundary validation. | Future question, not authorized. |
| `commit_idempotency.schema.json` | Duplicate prevention needs schema validation across fixtures or runs. | Future question, not authorized. |
| `compensation_record.schema.json` | Fixture-local compensation or supersession needs audit and evaluation beyond prose. | Future question, not authorized. |
| `committable_eval_result` fields | A future run reports side-effect planning or execution metrics repeatedly enough to require typed aggregation. | Future question, not authorized. |

## Acceptance Criteria For A Later Schema Batch

A later schema batch may be drafted only when it names:

- the accepted side-effect implementation spec requiring the schema
- the exact runtime or evaluation artifact that cannot be represented today
- the action enum, payload contract, and side-effect class mapping
- approval policy fields and approval record validation rules
- pre-effect and post-effect evidence fields
- rollback, compensation, or reconciliation enum values
- Episode Journal audit and replay requirements
- migration impact on existing Stage 1, G6, Lane A, and Lane B artifacts
- validation tests for every new required field or enum
- explicit proof that no `IRREVERSIBLE` or `MEMORY_WRITE` behavior is bundled
  into the `COMMITTABLE` schema change

## Rejection Conditions

A schema proposal must be rejected or kept at planning level if it:

- treats the existing `COMMITTABLE` enum as runtime authorization
- adds an action enum without an accepted implementation spec and verifier
  contract
- adds approval fields without an approval policy
- uses human labels as runtime approvals
- treats compensation as strict rollback
- allows source fixture mutation, path escape, external targets, production
  targets, memory writes, or irreversible effects
- claims H5 validation, production readiness, or runtime approval

## Related Documents

- [Post-Stage-1 Side-Effect Planning Draft Spec](../02_specs/Post_Stage_1_Side_Effect_Planning_Draft_Spec.md)
- [Post-Stage-1 Side-Effect Evaluation Plan](../04_experiments/Post_Stage_1_Side_Effect_Evaluation_Plan.md)
- [Side-Effect Escalation Gate](../00_manifest/Side_Effect_Escalation_Gate.md)
- [Execution IR and Episode Semantics](../02_specs/Execution_IR_and_Episode_Semantics.md)
- [Evidence Packet and Verifier Runtime](../02_specs/Evidence_Packet_and_Verifier_Runtime.md)
- [Commit Abort Replay Semantics](../02_specs/Commit_Abort_Replay_Semantics.md)
- [execution_step.schema.json](execution_step.schema.json)
- [planner_action_sequence.schema.json](planner_action_sequence.schema.json)
- [benchmark_task.schema.json](benchmark_task.schema.json)
- [evidence_packet.schema.json](evidence_packet.schema.json)
- [verifier_output.schema.json](verifier_output.schema.json)
- [episode_journal.schema.json](episode_journal.schema.json)
