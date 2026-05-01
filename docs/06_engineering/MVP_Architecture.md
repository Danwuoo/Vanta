# MVP Architecture

## Purpose

Translate the research documentation into a minimal implementation architecture without claiming the theory is validated.

## Architecture Overview

```text
Task Input
  -> Canonical State Manager
  -> Planner / Action Proposer
  -> Execution IR Compiler
  -> Verifier Runtime
  -> Action Executor
  -> Evidence Packet Builder
  -> Commit / Abort Controller
  -> Episode Journal
  -> Evaluation Harness
```

## MVP Modules

- Canonical State Manager: stores task intent, state summaries, and state hashes.
- Execution IR Compiler: turns action proposals into executable steps.
- Verifier Runtime: checks feasibility, safety, postconditions, and evidence sufficiency.
- Evidence Packet Builder: collects state, action, observation, verifier, and provenance data.
- Commit / Abort Controller: applies or rejects verified changes.
- Episode Journal: records runtime actions for audit and replay.
- Evaluation Harness: computes initial metrics from logged episodes.

## Deferred Modules

- Full Context OS.
- Long-term memory write gate.
- Training on runtime feedback.
- High-risk external action governance beyond sandbox tasks.

## Open Questions

- What controlled environment should the MVP use?
- Which verifier implementation is acceptable for first measurement?
- What runtime language and storage format should be used?
