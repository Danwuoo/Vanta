# Traceability Matrix

## Purpose

Trace concepts from theory through specs, schemas, experiments, evaluation, and engineering.

| Concept | Theory Source | Spec | Schema | Experiment | Metric / Labeling | Engineering |
| --- | --- | --- | --- | --- | --- | --- |
| Minimal closed loop | [Design Theory](../01_theory/Design_Theory.md) | [Minimal Closed Loop Runtime Spec](../02_specs/Minimal_Closed_Loop_Runtime_Spec.md) | `canonical_state.schema.json`, `execution_step.schema.json` | [Experiment 001](../04_experiments/Experiment_001_Minimal_Loop.md) | `task_success_rate`, `invalid_action_rate` | [MVP Architecture](../06_engineering/MVP_Architecture.md) |
| Execution IR | [Design Theory](../01_theory/Design_Theory.md) | [Execution IR and Episode Semantics](../02_specs/Execution_IR_and_Episode_Semantics.md) | `execution_step.schema.json` | [Experiment 001](../04_experiments/Experiment_001_Minimal_Loop.md) | `invalid_action_rate` | [Runtime Module Plan](../06_engineering/Runtime_Module_Plan.md) |
| Evidence Packet | [Design Theory](../01_theory/Design_Theory.md) | [Evidence Packet and Verifier Runtime](../02_specs/Evidence_Packet_and_Verifier_Runtime.md) | `evidence_packet.schema.json` | [Experiment 002](../04_experiments/Experiment_002_Evidence_Verifier.md) | `evidence_sufficiency_score`, `verifier_false_accept_rate`, `verifier_false_reject_rate` | [Runtime Module Plan](../06_engineering/Runtime_Module_Plan.md) |
| Commit / abort / replay | [Design Theory](../01_theory/Design_Theory.md) | [Commit Abort Replay Semantics](../02_specs/Commit_Abort_Replay_Semantics.md) | `episode_journal.schema.json` | [Experiment 003](../04_experiments/Experiment_003_Commit_Journal.md) | `commit_integrity_score`, `replay_consistency`, `audit_completeness` | [Testing Strategy](../06_engineering/Testing_Strategy.md) |
| Failure Taxonomy | [Design Theory](../01_theory/Design_Theory.md) | [Failure Taxonomy v0](../02_specs/Failure_Taxonomy_v0.md) | `eval_result.schema.json` | [Ablation Plan](../04_experiments/Ablation_Plan.md) | [Failure Labeling Guide](../05_evaluation/Failure_Labeling_Guide.md) | [Runtime Module Plan](../06_engineering/Runtime_Module_Plan.md) |
| MVP prioritization | [Validation Report](../01_theory/Validation_and_Refutation_Report.md) | All MVP specs | All schemas | All experiments | [Metrics Definition](../05_evaluation/Metrics_Definition.md) | [Implementation Timeline](../06_engineering/Implementation_Timeline.md) |
| Stage 0 boundary lock | [Design Theory Stage 0](../01_theory/Design_Theory.md#stage-0-lock-conceptual-boundaries) | [Stage 0 Boundary Lock](Stage_0_Boundary_Lock.md) | `canonical_state.schema.json`, `evidence_packet.schema.json`, `verifier_output.schema.json`, `episode_journal.schema.json`, `working_set.schema.json` | Stage 0 governance gate before experiments | [Failure Labeling Guide](../05_evaluation/Failure_Labeling_Guide.md) | [Runtime Module Plan](../06_engineering/Runtime_Module_Plan.md) |
| Context OS / Working Set Compiler | [Design Theory](../01_theory/Design_Theory.md) | [Context OS and Working Set Compiler Note](../02_specs/Context_OS_and_Working_Set_Compiler_Note.md) | `working_set.schema.json` | [Ablation Plan Stage E](../04_experiments/Ablation_Plan.md) | Context omission and provenance metrics remain open | [Implementation Timeline Phase 5](../06_engineering/Implementation_Timeline.md) |

## Open Questions

- Which concepts should become normative interfaces in v1?
- Which traceability rows need automated checks?
