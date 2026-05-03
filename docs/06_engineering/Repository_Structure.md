# Repository Structure

## Purpose

Define the intended repository organization as the documentation system evolves into implementation.

## Current Documentation Tree

```text
docs/
  00_manifest/
  01_theory/
  02_specs/
  03_schemas/
  04_experiments/
    fixtures/
  05_evaluation/
  06_engineering/
lib/
  vanta/
test/
  fixtures/
  vanta/
```

## Runtime Areas

```text
lib/
  vanta/
    state_manager.ex
    planner_adapter.ex
    open_ai_planner_adapter.ex
    open_claw_planner_adapter.ex
    execution_ir_compiler.ex
    action_executor.ex
    evidence_builder.ex
    verifier_runtime.ex
    commit_controller.ex
    episode_journal.ex
    runtime.ex
    baseline_runner.ex
    replay_runner.ex
    experiment001.ex
    evaluation_harness.ex
  mix/tasks/
    vanta.experiment001.ex
test/
  fixtures/
  vanta/
```

## Rules

- Theory changes should not directly mutate implementation behavior.
- Schemas should be versioned before runtime logs depend on them.
- Experiments should store results separately from design docs.
- Generated artifacts should be ignored or clearly separated from source docs.
- Document Ops fixtures are mirrored under `docs/04_experiments/fixtures/` and
  `test/fixtures/`; tests must fail if the trees diverge.

## Open Questions

- Should schema files be promoted into a package when implementation starts?
