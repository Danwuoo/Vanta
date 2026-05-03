# MVP Architecture

## Purpose

Translate the research documentation into a minimal implementation architecture without claiming the theory is validated.

## Architecture Overview

```text
Task Input
  -> Canonical State Manager
  -> Planner / Action Proposer
  -> Execution IR Compiler
  -> Action Executor
  -> Evidence Packet Builder
  -> Verifier Runtime
  -> Commit / Abort Controller
  -> Episode Journal
  -> Evaluation Harness
```

## Stage 1 Locked Decisions

- Closure status: `Closed: local smoke completed`.
- Controlled environment: local Document Ops fixtures.
- Runtime language: Elixir/Mix.
- Verifier v0: deterministic rule-based verifier using schema validation,
  side-effect-class checks, required evidence checks, provenance checks, and
  fixture-specific acceptance checks.
- Allowed side-effect classes: `READ_ONLY`, `SIMULATED`, and `REVERSIBLE`.
- Disallowed in Stage 1: full Context OS, memory writes, irreversible external
  actions, production deployment, and unmeasured Experiment 001 result reporting.

## MVP Modules

- Canonical State Manager: stores task intent, state summaries, and state hashes.
- Execution IR Compiler: turns action proposals into executable steps.
- Verifier Runtime: checks feasibility, safety, postconditions, and evidence sufficiency.
- Evidence Packet Builder: collects state, action, observation, verifier, and provenance data.
- Commit / Abort Controller: applies or rejects verified changes.
- Episode Journal: records runtime actions for audit and replay.
- Evaluation Harness: computes initial metrics from logged episodes.
- Runtime Orchestrator: wires the Stage 1 loop as `Vanta.Runtime.run_task/3`.
- Baseline Runner: executes LLM action sequences directly without governance
  artifacts for Experiment 001 comparison.
- Replay Runner: replays journal steps in clean fixture workspaces.

## Deferred Modules

- Full Context OS.
- Long-term memory write gate.
- Training on runtime feedback.
- High-risk external action governance beyond sandbox tasks.

## Post-Stage-1 Open Questions

- What storage format should replace fixture-local in-memory/file artifacts after
  the Phase 1 skeleton?
- What benchmark size is required before broader measured comparison?
- What benchmark size and direct Responses comparison are required before the
  OpenClaw `openai-codex/gpt-5.4-mini` candidate canonical local baseline can be
  promoted beyond Stage 1 smoke status?
