# Project Manifest

## Purpose

Vanta is a research and engineering program for an agent runtime centered on learned cognition, executable action, evidence, verification, context governance, memory discipline, failure attribution, and replay-safe execution.

This manifest defines the documentation system and prevents theory documents from directly controlling implementation without passing through specs, schemas, experiments, and evaluation.

## Documentation Layers

| Layer | Directory | Role |
| --- | --- | --- |
| L0 | `00_manifest` | Governance, scope, traceability, terminology, and document operations |
| L1 | `01_theory` | Source theory, research hypotheses, validation review, and alternative theories |
| L2 | `02_specs` | Implementable MVP specifications derived from the theory layer |
| L3 | `03_schemas` | Interoperable runtime, benchmark, and evaluation data contracts |
| L4 | `04_experiments` | Benchmark and ablation experiment design |
| L5 | `05_evaluation` | Metrics, labeling guides, and report templates |
| L6 | `06_engineering` | Architecture, module planning, timeline, and testing strategy |

## Governance Rules

- `Design_Theory.md` is the conceptual source of truth, not an implementation spec.
- `Validation_and_Refutation_Report.md` is an evidence and risk review, not proof of validation.
- Engineering work must be justified by specs, schemas, and tests, not by theory prose alone.
- Experimental claims must remain `TODO`, `Not yet run`, or `Open Questions` until measured.
- Changes to core concepts must update the traceability matrix and decision log.

## MVP Positioning

The MVP should focus on the minimal closed loop:

```text
state -> plan -> action -> evidence -> verify -> commit / abort
```

Targeted recovery, Context OS, long-term memory governance, and advanced execution governance should be staged after the minimal loop has measurable behavior.

## Source Documents

- [Design Theory](../01_theory/Design_Theory.md)
- [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
