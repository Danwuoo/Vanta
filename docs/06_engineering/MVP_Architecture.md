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

## Current Status And Boundaries

- Closure status: `Closed: local smoke completed`.
- Controlled environment: local Document Ops fixtures.
- Runtime language: Elixir/Mix.
- Verifier v0: deterministic rule-based verifier using schema validation,
  side-effect-class checks, required evidence checks, provenance checks, and
  fixture-specific acceptance checks.
- Current executable side-effect classes: `READ_ONLY`, `SIMULATED`, and
  `REVERSIBLE` fixture-local Document Ops actions.
- `PS1-G6` is locally implemented as `Document Ops Structured Edit Action
  Surface v0` without expanding side-effect classes or making H1-H5 validation
  claims.
- The `20260601_113121` Lane A run is accepted by closure for the named
  threshold-governed Document Ops sample only.
- `PS1-G7` Context OS and `PS1-G8` side-effect work remain specification,
  schema-impact, evaluation, and implementation planning only.
- Disallowed in the current runtime: full Context OS, memory writes,
  irreversible external actions, production deployment, executable
  `COMMITTABLE` actions, and H1-H5 validation claims.

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
- Document Ops Structured Edit Surface: inspects document structure, validates
  document contracts, simulates structured edits, and applies reversible
  fixture-local structured edits under `PS1-G6`.
- Working Set Compiler v0: produces schema-valid, reference-backed working sets
  for controlled long-context fixtures without implementing full Context OS.
- Post-Stage-1 tooling: generates larger-sample artifacts, Lane B packet and
  label-result artifacts, and `PS1-G8` side-effect planning scaffolds without
  changing the commit path.

## Deferred Modules

- Full Context OS.
- Long-term memory write gate.
- Training on runtime feedback.
- Runtime execution of `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE`
  side effects.
- Packaged runtime schema assets; current schemas remain under
  `docs/03_schemas/*.schema.json`.
- High-risk external action governance beyond fixture-local tasks.

## Post-Stage-1 Open Questions

- What storage format should replace fixture-local in-memory/file artifacts after
  the Phase 1 skeleton?
- What successor measured-comparison scope is required beyond the accepted
  `20260601_113121` Lane A Document Ops sample?
- What benchmark size and direct Responses comparison are required before the
  OpenClaw `openai-codex/gpt-5.4-mini` candidate canonical local baseline can be
  promoted beyond Stage 1 smoke status?
