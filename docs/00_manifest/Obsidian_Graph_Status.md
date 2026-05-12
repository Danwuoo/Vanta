---
tags:
  - vanta/l0
  - vanta/obsidian
  - vanta/status
graph_role: graph_status
graph_layer: L0
status: active
---

# Obsidian Graph Status

## Purpose

This note defines the intended Obsidian graph view for the Vanta documentation
system. It is a navigation and status aid only. It does not replace
[[docs/00_manifest/Project_Manifest|Project Manifest]],
[[docs/00_manifest/Document_Map|Document Map]], or
[[docs/00_manifest/Traceability_Matrix|Traceability Matrix]].

## Current Graph Policy

Use the root hub as the primary entry point:

[[docs/Vanta_Documentation_Graph|Vanta Documentation Graph]]

Default global graph query:

```text
path:docs -path:docs/04_experiments/fixtures -path:docs/04_experiments/results
```

This keeps canonical documentation visible while hiding fixture input notes and
historical run-summary artifacts that otherwise dominate the graph as isolated
or weakly connected nodes.

## Inventory Snapshot

| Scope | Count | Obsidian treatment |
| --- | ---: | --- |
| All markdown notes under `docs/` | 104 | Too noisy for the default global graph. |
| Canonical markdown notes excluding fixtures and results | 68 | Default graph scope. |
| Fixture input markdown notes | 20 | Hidden by default; inspect through fixture folders when needed. |
| Historical result summary markdown notes | 16 | Hidden by default; inspect through experiment report links when needed. |
| Root plus layer index notes | 8 | Hub spine for local graph navigation. |
| Canonical notes without frontmatter | 57 | Expected for now; do not use frontmatter tags as the complete inventory source. |

## Hub Spine

Open local graph from the root hub with depth 2 or 3.

[[docs/Vanta_Documentation_Graph|Root]]
-> [[docs/00_manifest/Manifest_Index|L0 Manifest]]
-> [[docs/01_theory/Theory_Index|L1 Theory]]
-> [[docs/02_specs/Specs_Index|L2 Specs]]
-> [[docs/03_schemas/Schemas_Index|L3 Schemas]]
-> [[docs/04_experiments/Experiments_Index|L4 Experiments]]
-> [[docs/05_evaluation/Evaluation_Index|L5 Evaluation]]
-> [[docs/06_engineering/Engineering_Index|L6 Engineering]]

## Current Post-Stage-1 Workbench

For `PS1-G1` through `PS1-G8`, use:

[[docs/00_manifest/Post_Stage_1_Advancement_Gate|Post-Stage-1 Advancement Gate]]
-> [[docs/00_manifest/Post_Stage_1_Gate_Inventory|Post-Stage-1 Gate Inventory]]
-> [[docs/04_experiments/Post_Stage_1_Larger_Sample_Plan|Post-Stage-1 Larger Sample Plan]]
-> [[docs/04_experiments/Baseline_Identity_Plan|Baseline Identity Plan]]
-> [[docs/05_evaluation/Post_Stage_1_Metric_Policy|Post-Stage-1 Metric Policy]]
-> [[docs/05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy|Post-Stage-1 Labeling Scope and Adjudication Policy]]
-> [[docs/00_manifest/Post_Stage_1_Runtime_Scope_Proposal|Post-Stage-1 Runtime Scope Proposal]]
-> [[docs/00_manifest/Context_OS_Expansion_Gate|Context OS Expansion Gate]]
-> [[docs/00_manifest/Side_Effect_Escalation_Gate|Side-Effect Escalation Gate]]

## Layer Status

| Layer | Hub | Current status |
| --- | --- | --- |
| L0 manifest | [[docs/00_manifest/Manifest_Index|Manifest Index]] | Active governance and post-Stage-1 routing source. |
| L1 theory | [[docs/01_theory/Theory_Index|Theory Index]] | Source theory and validation review; not implementation authority. |
| L2 specs | [[docs/02_specs/Specs_Index|Specs Index]] | MVP contracts plus implemented PS1-G6 structured edit and planning-only PS1-G8 boundaries. |
| L3 schemas | [[docs/03_schemas/Schemas_Index|Schemas Index]] | Existing data contracts plus PS1-G6 structured edit action payload contracts. |
| L4 experiments | [[docs/04_experiments/Experiments_Index|Experiments Index]] | Stage 1 local smoke complete; larger PS1 sample not yet run. |
| L5 evaluation | [[docs/05_evaluation/Evaluation_Index|Evaluation Index]] | Metric and labeling policies accepted; labels not yet collected. |
| L6 engineering | [[docs/06_engineering/Engineering_Index|Engineering Index]] | Implementation planning remains downstream of accepted specs and schemas. |

## Gate Status

| Gate | Status | Owner artifact | Boundary |
| --- | --- | --- | --- |
| `PS1-G1` | Accepted | [[docs/04_experiments/Post_Stage_1_Larger_Sample_Plan|Larger Sample Plan]] | 48-fixture sample frame; not yet run. |
| `PS1-G2` | Accepted | [[docs/05_evaluation/Post_Stage_1_Metric_Policy|Metric Policy]] | Threshold policy; no measured acceptance yet. |
| `PS1-G3` | Accepted | [[docs/05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy|Labeling Policy]] | Evidence sufficiency scale fixed; labels not collected. |
| `PS1-G4` | Accepted | [[docs/05_evaluation/Post_Stage_1_Labeling_Scope_and_Adjudication_Policy|Labeling Policy]] | Double-review and adjudication policy fixed; labels not collected. |
| `PS1-G5` | Accepted | [[docs/04_experiments/Baseline_Identity_Plan|Baseline Identity Plan]] | OpenClaw remains harness-labeled; direct API arms are separate. |
| `PS1-G6` | Accepted for planning | [[docs/00_manifest/Post_Stage_1_Runtime_Scope_Proposal|Runtime Scope Proposal]] | Structured edit action surface planning only; no schema/runtime implementation. |
| `PS1-G7` | Accepted for planning | [[docs/00_manifest/Context_OS_Expansion_Gate|Context OS Expansion Gate]] | Context OS spec/eval planning only; no full Context OS. |
| `PS1-G8` | Accepted for planning | [[docs/00_manifest/Side_Effect_Escalation_Gate|Side-Effect Escalation Gate]] | Side-effect planning only; no `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` execution. |

## Graph Hygiene Rules

- Keep root and layer index notes as the Obsidian graph spine.
- Keep fixtures and results out of the default graph query.
- Use [[docs/00_manifest/Document_Map|Document Map]] for reading order.
- Use [[docs/00_manifest/Traceability_Matrix|Traceability Matrix]] for
  source-to-implementation relationships.
- Use [[docs/00_manifest/Post_Stage_1_Gate_Inventory|Post-Stage-1 Gate Inventory]]
  for gate owner artifacts and routing status.
- Do not treat frontmatter tags as complete coverage until canonical notes have
  been normalized.

## Open Cleanup

- Normalize frontmatter on canonical non-index notes if tag-based graph filters
  become necessary.
- Decide whether fixture input notes should receive a `vanta/fixture` tag or
  remain hidden by path query only.
- Decide whether old result summaries should be archived outside the default
  vault graph or kept as hidden historical artifacts.
