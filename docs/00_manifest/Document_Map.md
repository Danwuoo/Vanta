# Document Map

## Purpose

Map how documents relate so readers can navigate from theory to implementation without treating conceptual material as executable specification.

## Reading Order

1. [Project Manifest](Project_Manifest.md)
2. [Stage 0 Boundary Lock](Stage_0_Boundary_Lock.md)
3. [Design Theory](../01_theory/Design_Theory.md)
4. [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
5. [Research Hypotheses](../01_theory/Research_Hypotheses.md)
6. [Minimal Closed Loop Runtime Spec](../02_specs/Minimal_Closed_Loop_Runtime_Spec.md)
7. [Context OS and Working Set Compiler Note](../02_specs/Context_OS_and_Working_Set_Compiler_Note.md)
8. [Metrics Definition](../05_evaluation/Metrics_Definition.md)
9. [Ablation Plan](../04_experiments/Ablation_Plan.md)
10. [MVP Architecture](../06_engineering/MVP_Architecture.md)

## Layer Responsibilities

- Manifest documents define governance, traceability, and locked conceptual boundaries.
- Theory documents preserve conceptual sources and research pressure tests.
- Specs convert concepts into implementable MVP behavior.
- Schemas define portable data shapes.
- Experiments define how claims will be tested.
- Evaluation documents define metrics and labeling rules.
- Engineering documents define build sequencing and module boundaries.

## Stage 0 Gate

[Stage 0 Boundary Lock](Stage_0_Boundary_Lock.md) is the routing source for
conceptual boundary decisions before Stage 1 implementation. It does not validate
the architecture and does not replace downstream specs, schemas, experiments, or
evaluation documents.

## Translation Sources

- `docs/01_theory/設計構想與理論.md` -> [Design Theory](../01_theory/Design_Theory.md)
- `docs/01_theory/研讀驗證與反駁報告.md` -> [Validation and Refutation Report](../01_theory/Validation_and_Refutation_Report.md)
