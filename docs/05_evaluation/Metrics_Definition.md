# Metrics Definition

## Purpose

Define MVP metrics for Vanta evaluation. Thresholds are open until empirical baselines exist.

## `task_success_rate`

- Definition: Fraction of benchmark tasks completed according to task-specific success criteria.
- Formula or computation rule: `successful_tasks / total_tasks`.
- Required fields: `task_id`, task success label, evaluator identity, task criteria version.
- Interpretation: Higher is better, but it must not be interpreted without process-integrity metrics.
- Failure modes: Inflated by weak success criteria, hidden invalid actions, or evaluator inconsistency.

## `invalid_action_rate`

- Definition: Fraction of actions judged invalid, unsafe, malformed, or unsupported by state and evidence.
- Formula or computation rule: `invalid_actions / total_actions`.
- Required fields: `step_id`, action validity label, side-effect class, evaluator identity.
- Interpretation: Lower is better; reductions should be checked against false reject and abstention behavior.
- Failure modes: Under-counted when logs omit failed actions or when validators only inspect final output.

## `verifier_false_accept_rate`

- Definition: Fraction of invalid items accepted by the verifier.
- Formula or computation rule: `invalid_items_accepted / invalid_items_reviewed`.
- Required fields: verifier decision, ground-truth validity label, evidence packet ID, task type.
- Interpretation: Lower is better; this is high priority for side-effectful actions.
- Failure modes: Requires reliable invalid-item labels; may be distorted by class imbalance.

## `verifier_false_reject_rate`

- Definition: Fraction of valid items rejected by the verifier.
- Formula or computation rule: `valid_items_rejected / valid_items_reviewed`.
- Required fields: verifier decision, ground-truth validity label, evidence packet ID, task type.
- Interpretation: Lower is better, but some increase may be acceptable if false accepts fall substantially.
- Failure modes: Overly conservative verifier may reduce task completion without improving safety.

## `evidence_sufficiency_score`

- Definition: Mean labeled sufficiency of evidence supporting a verifier decision or commit.
- Formula or computation rule: `mean(labeled_sufficiency_score)` over evaluated evidence packets.
- Required fields: evidence packet ID, sufficiency label, label scale, evaluator identity.
- Interpretation: Higher means evidence is more complete, grounded, and auditable.
- Failure modes: Scores may be inflated if labels reward fluent explanations rather than provenance-backed evidence.

## `commit_integrity_score`

- Definition: Fraction of commits passing journal, verification, and side-effect integrity checks.
- Formula or computation rule: `commits_passing_integrity_checks / total_commits`.
- Required fields: commit ID, episode ID, verifier output, side-effect class, journal completeness label.
- Interpretation: Higher is better; low values indicate unsafe or unauditable application of changes.
- Failure modes: Can be gamed by committing fewer actions or classifying risky actions as low risk.

## `replay_consistency`

- Definition: Fraction of replay attempts that reconstruct the same accepted state or an explicitly equivalent state.
- Formula or computation rule: `consistent_replay_runs / replay_attempts`.
- Required fields: episode ID, runtime manifest, tool/environment versions, state hashes, replay result.
- Interpretation: Higher is better in controlled environments.
- Failure modes: Non-deterministic tools, missing version metadata, or irreversible external effects can invalidate comparison.

## `audit_completeness`

- Definition: Fraction of episodes containing all required audit fields.
- Formula or computation rule: `episodes_containing_required_audit_fields / total_episodes`.
- Required fields: episode ID, required audit field checklist, journal, evidence references, verifier outputs.
- Interpretation: Higher is better; it measures reviewability, not correctness by itself.
- Failure modes: Complete logs can still contain incorrect evidence or wrong verifier decisions.

## Open Questions

- What label scale should be used for evidence sufficiency?
- What metric thresholds define MVP acceptance?
- Which metrics require double human annotation?
