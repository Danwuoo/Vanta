# Runtime Module Plan

## Purpose

Define candidate runtime modules and their responsibilities for a first MVP.

## Modules

| Module | Responsibility | Initial Status |
| --- | --- | --- |
| State Manager | Maintain canonical state and state hashes. | Implemented for Stage 1 prototype |
| Planner Adapter | Produce candidate action sequences from task and state. | Implemented for fixture recipes, OpenAI env-gated baseline, and OpenClaw local agent harness candidate baseline |
| Execution IR Compiler | Normalize actions into executable steps. | Implemented for Stage 1 action scope |
| Action Executor | Execute or simulate allowed fixture-local actions. | Implemented for Stage 1 action scope |
| Evidence Builder | Create Evidence Packet records. | Implemented for Stage 1 required evidence |
| Verifier Runtime | Accept, reject, abstain, or request evidence. | Implemented as deterministic Verifier v0 with fixture acceptance checks |
| LLM Verifier Adapter | Evaluate verifier input arms without entering the commit path. | Implemented for Experiment 002 through OpenClaw local harness |
| Commit Controller | Commit, abort, rollback, or reconcile. | Implemented for accept-only commit and reversible rollback metadata checks |
| Episode Journal | Persist replay and audit data. | Implemented for Stage 1 in-memory/file fixture prototype |
| Evaluation Harness | Compute metrics from logs. | Implemented for initial audit and experiment metrics |
| Runtime Orchestrator | Run `state -> plan -> action -> evidence -> verify -> commit / abort`. | Implemented as `Vanta.Runtime.run_task/3` |
| Baseline Runner | Execute LLM action sequences without governance artifacts. | Implemented for Experiment 001 baseline |
| Replay Runner | Re-run journal steps in a clean fixture workspace. | Implemented for deterministic fixture replay |

## Planner Adapter Notes

- `Vanta.OpenAIPlannerAdapter` calls the OpenAI Responses API directly and
  requires `OPENAI_API_KEY`.
- `Vanta.OpenClawPlannerAdapter` calls
  `wsl.exe -- bash -lic "cd ~/openclaw && pnpm openclaw ..."` and defaults to
  `openai-codex/gpt-5.4-mini`.
- OpenClaw adapter results are not pure model-only results. They include the
  OpenClaw local agent harness and must be labeled accordingly in experiment
  reports.
- `Vanta.OpenClawVerifierAdapter` reuses the OpenClaw local harness pattern for
  Experiment 002 verifier judging and normalizes malformed verifier responses to
  `abstain` for parse failures.

## Stage 1 Closure Status

Stage 1 and Experiment 001 are closed as `Closed: local smoke completed`. The
implemented modules above are sufficient for the local Document Ops smoke phase;
storage, benchmark scale, and broader baseline comparison are post-Stage-1 work.

## Boundary Rules

- Execution IR must not become the canonical reasoning state.
- Tool outputs must be normalized before state update.
- Memory writes are deferred and disallowed in Stage 1.
- Irreversible actions are out of MVP scope.
- Stage 1 allows only `READ_ONLY`, `SIMULATED`, and `REVERSIBLE` fixture-local
  Document Ops actions.

## Post-Stage-1 Open Questions

- What storage backend should the journal use after the in-memory/file fixture
  prototype?
- What benchmark size is required before moving beyond Stage 1 smoke checks?
- What measured threshold, after a real LLM baseline run, is sufficient to move
  beyond local Document Ops fixtures?
