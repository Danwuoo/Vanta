# Runtime Module Plan

## Purpose

Define candidate runtime modules and their responsibilities for a first MVP.

## Modules

| Module | Responsibility | Initial Status |
| --- | --- | --- |
| State Manager | Maintain canonical state and state hashes. | TODO |
| Planner Adapter | Produce candidate actions from task and state. | TODO |
| Execution IR Compiler | Normalize actions into executable steps. | TODO |
| Action Executor | Execute or simulate allowed actions. | TODO |
| Evidence Builder | Create Evidence Packet records. | TODO |
| Verifier Runtime | Accept, reject, abstain, or request evidence. | TODO |
| Commit Controller | Commit, abort, rollback, or reconcile. | TODO |
| Episode Journal | Persist replay and audit data. | TODO |
| Evaluation Harness | Compute metrics from logs. | TODO |

## Boundary Rules

- Execution IR must not become the canonical reasoning state.
- Tool outputs must be normalized before state update.
- Memory writes are deferred unless explicitly in experiment scope.
- Irreversible actions are out of MVP scope.

## Open Questions

- What storage backend should the journal use?
- Should verifier be synchronous for every action in Stage 1?
- What is the smallest useful action schema registry?
