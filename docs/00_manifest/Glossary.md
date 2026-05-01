# Glossary

## Purpose

This glossary freezes working terminology for the Vanta documentation system. Definitions are operational drafts, not final empirical claims.

| Term | Working Definition |
| --- | --- |
| canonical state | Shared reasoning state used to maintain cross-module consistency and attribution. |
| Execution IR | Action-level intermediate representation for executable steps, dependencies, side-effect classes, and commit or rollback boundaries. |
| Evidence Packet | Structured evidence unit consumed by verifier, recovery, audit, and regression systems. |
| Context OS | Runtime layer that compiles long-term information into the current working set. |
| Episode Journal | Transaction-style journal of steps, state hashes, evidence, verifier results, commit status, rollback status, and memory effects. |
| Failure Taxonomy | Classification system for representation, procedure, search, memory, abstraction, evaluation, and execution governance failures. |
| Credit Routing | Runtime assignment of failure credit to the subsystem or capability most likely responsible for a failure. |
| Targeted Recovery | Recovery action selected according to failure class rather than blind retry. |
| Verifier Runtime | Runtime service that checks action feasibility, safety, postconditions, evidence sufficiency, branch consistency, memory writes, rollback legitimacy, and final correctness. |
| commit | Applying a verified state or side effect into the runtime's accepted state. |
| rollback | Returning a reversible action or state transition to a prior valid state. |
| replay | Reconstructing or re-executing an episode from logged state, action, evidence, runtime, and tool metadata. |
| provenance | Source and version information needed to audit, verify, or reproduce an observation, action, memory item, or result. |

## Open Questions

- Which terms need formal schema-level definitions before MVP implementation?
- Which terms should be narrowed to avoid overlap with existing agent literature?
