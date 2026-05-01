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
  05_evaluation/
  06_engineering/
```

## Future Implementation Areas

```text
src/
  state/
  execution_ir/
  verifier/
  evidence/
  journal/
  evaluation/
tests/
  unit/
  integration/
  fixtures/
```

## Rules

- Theory changes should not directly mutate implementation behavior.
- Schemas should be versioned before runtime logs depend on them.
- Experiments should store results separately from design docs.
- Generated artifacts should be ignored or clearly separated from source docs.

## Open Questions

- Should schema files be promoted into a package when implementation starts?
- Should benchmark fixtures live under `docs` or `tests/fixtures`?
