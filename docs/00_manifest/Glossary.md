# Glossary

## Purpose

This glossary freezes working terminology for the Vanta documentation system. Definitions are operational drafts, not final empirical claims.

| Term | Working Definition |
| --- | --- |
| canonical state | Shared accepted task-relevant state used to maintain cross-module consistency and attribution. It is not an execution trace or raw tool log. |
| Execution IR | Action-level intermediate representation for executable steps, dependencies, side-effect classes, and commit or rollback boundaries. |
| Evidence Packet | Structured evidence unit consumed by verifier, recovery, audit, and regression systems. |
| Context OS | Runtime layer that compiles long-term information into the current working set; it is not long-context stuffing. |
| Working Set | Budget-aware, provenance-backed context artifact selected for the active goal from state, memory, evidence, constraints, and recovery context. |
| Working Set Compiler | Context OS component that selects and records working set references, selection policy, rationale, budget, provenance, and known omissions. |
| Episode Journal | Transaction-style journal of steps, state hashes, evidence, verifier results, commit status, rollback status, and memory effects. It is not durable memory. |
| Failure Taxonomy | Classification system for representation, procedure, search, memory, abstraction, evaluation, and execution governance failures. |
| Credit Routing | Runtime assignment of failure credit to the subsystem or capability most likely responsible for a failure. |
| Targeted Recovery | Recovery action selected according to failure class rather than blind retry. |
| Verifier Runtime | Runtime service that checks action feasibility, safety, postconditions, evidence sufficiency, branch consistency, memory writes, rollback legitimacy, and final correctness. It is not only final-answer judging. |
| commit | Applying a verified state or side effect into the runtime's accepted state. |
| rollback | Returning a reversible action or state transition to a prior valid state. |
| replay | Reconstructing or re-executing an episode from logged state, action, evidence, runtime, and tool metadata. |
| provenance | Source and version information needed to audit, verify, or reproduce an observation, action, memory item, or result. |
| tool log | Raw record of tool calls and outputs. It may provide provenance or observations, but it is not canonical state. |
| memory append | Governed write to a memory store or memory candidate set. It is not learning unless a training process and evaluation document define it as such. |
| final-answer judging | Evaluation that inspects only the final answer. It is insufficient for Stage 1 verifier semantics when actions, evidence, and side effects must be checked. |

## Open Questions

- Which terms need formal schema-level definitions before MVP implementation?
- Which terms should be narrowed to avoid overlap with existing agent literature?
