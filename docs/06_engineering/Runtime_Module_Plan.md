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
| OpenClaw Recovery Adapter | Classify Phase 4 failures and propose a recovery policy through the OpenClaw local harness. | Implemented and exercised by Experiment 004 local smoke |
| Recovery Policy | Execute allowlisted fixture-local recovery policies. | Implemented and exercised by rollback reconstruction, audit-ref repair, and compensation record creation fixtures |
| Recovery Runner | Run failed episodes, request Recovery Decisions, and apply targeted recovery. | Implemented and exercised by Phase 4 fixtures |
| Blind Retry Runner | Repeat the original action sequence with matched budget and no failure labels or policy hints. | Implemented and exercised by Experiment 004 baseline |
| Working Set Compiler | Compile schema-valid, reference-backed `WorkingSet` artifacts from explicit candidate refs under a fixed budget. | Planned for Phase 5 / Experiment 005 |
| Raw Trace Context Builder | Build bounded raw-trace baseline context under the same budget as treatment. | Planned for Phase 5 / Experiment 005 |
| OpenClaw Context Planner Adapter | Ask OpenClaw for JSON action sequences using embedded baseline or working-set context only. | Planned for Phase 5 / Experiment 005 |

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
- `Vanta.OpenClawContextPlannerAdapter` reuses the local harness pattern for
  Experiment 005. It must not allow tool use inside the OpenClaw prompt and must
  label outputs as OpenClaw harness results, not pure model-only results.

## Stage 1 Closure Status

Stage 1 and Experiment 001 are closed as `Closed: local smoke completed`. The
implemented modules above are sufficient for the local Document Ops smoke phase;
storage, benchmark scale, and broader baseline comparison are post-Stage-1 work.

## Boundary Rules

- Execution IR must not become the canonical reasoning state.
- Tool outputs must be normalized before state update.
- Memory writes are deferred and disallowed in Stage 1.
- Irreversible actions are out of MVP scope.
- Stage 1 smoke used only `READ_ONLY`, `SIMULATED`, and `REVERSIBLE`
  fixture-local Document Ops actions. Phase 4 adds fixture-local
  `COMPENSABLE` handling without executing irreversible external actions.
- Phase 5 `Working Set Compiler v0` is an experiment wrapper artifact producer
  and must not change the `Vanta.Runtime.run_task/3` commit path.
- Phase 5 must not introduce memory writes, full memory dumps, or raw tool log
  dumps as working sets.

## Post-Stage-1 Open Questions

- What storage backend should the journal use after the in-memory/file fixture
  prototype?
- What benchmark size is required before moving beyond Stage 1 smoke checks?
- What measured threshold, after a real LLM baseline run, is sufficient to move
  beyond local Document Ops fixtures?
