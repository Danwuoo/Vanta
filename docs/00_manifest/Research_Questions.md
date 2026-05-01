# Research Questions

## Purpose

This document converts the theory and validation review into research questions that can be tested through specifications, schemas, benchmarks, and experiments.

## Primary Questions

1. Does explicit reasoning-to-action structure improve task success and reduce invalid action rates compared with a baseline function-calling agent?
2. Does an Evidence Packet improve verifier reliability compared with final-answer or raw-trace judging?
3. Does a Context OS / working set compiler improve long-task stability under fixed token and latency budgets?
4. Does Failure Taxonomy plus Credit Routing improve recovery efficiency compared with blind retry or deeper search under matched compute?
5. Does Episode Journal governance reduce unsafe commits and improve replay, audit, and rollback quality?

## Secondary Questions

- Which parts of the runtime produce value independently, and which require the full loop?
- Which metrics can be computed automatically, and which require human labels?
- Which side-effect classes can be safely handled in the MVP?
- What data is required before runtime feedback can be used as a training signal?

## Open Questions

- What is the first vertical benchmark domain: document operations, research assistant tasks, code repair, or another controlled environment?
- What verifier architecture should be used in the first MVP: rule-based, model-based, human-assisted, or hybrid?
- What thresholds define acceptable false accept, false reject, and unsafe action rates?

## Related Documents

- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
- [Ablation Plan](../04_experiments/Ablation_Plan.md)
- [Metrics Definition](../05_evaluation/Metrics_Definition.md)
