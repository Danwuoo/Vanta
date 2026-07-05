# Repository Structure

## Purpose

Document the current Post-Stage-1 repository organization and navigation rules.
This file records the tree as it exists today; it is not an instruction to move
historical artifacts, result directories, fixtures, label packets, or runtime
source files.

## Current Root Layout

```text
.
  docs/             Documentation source, schemas, protocols, results, reports
  lib/              Elixir runtime, adapters, runners, and Mix tasks
  test/             ExUnit tests and executable fixture mirror
  chatgpt_docs/     ChatGPT Project Knowledge export mirror, capped at 25 files
  deps/             Mix dependency checkout, generated/local artifact
  _build/           Mix build output, generated/local artifact
  .elixir_ls/       Local editor/language-server artifact
  mix.exs
  mix.lock
  AGENTS.md
```

`docs/`, `lib/`, `test/`, and `chatgpt_docs/` are the relevant authored or
curated trees. `deps/`, `_build/`, and `.elixir_ls/` are local generated
artifacts and are not documentation, schema, experiment, evaluation, or runtime
source-of-truth paths.

## Artifact Classes

| Class | Current path | Navigation rule |
| --- | --- | --- |
| Documentation source | `docs/00_manifest/`, `docs/01_theory/`, `docs/02_specs/`, `docs/04_experiments/*.md`, `docs/05_evaluation/*.md`, `docs/06_engineering/` | Follow [Document Map](../00_manifest/Document_Map.md) and manifest precedence before treating downstream material as authoritative. |
| Schemas | `docs/03_schemas/*.schema.json` | Use [Schemas Index](../03_schemas/Schemas_Index.md) as the L3 navigation entry. Schema files define data contracts. |
| Schema impact reviews | `docs/03_schemas/Post_Stage_1_Context_OS_Schema_Impact_Review.md`, `docs/03_schemas/Post_Stage_1_Side_Effect_Schema_Impact_Review.md` | Review documents only. They record no-change decisions and do not add schema enum behavior. |
| Experiment protocols | `docs/04_experiments/*.md` outside `fixtures/` and `results/` | Protocols, plans, and benchmark definitions. They do not report results unless a measured run artifact or evaluation report is linked. |
| Experiment results | `docs/04_experiments/results/<experiment>/<timestamp>/` | Use [Experiment Results README](../04_experiments/results/README.md) as the L4 result navigation entry. Preserve historical, failed, superseded, timeout, partial, measured, and planning-only result directories as provenance. |
| Evaluation reports | `docs/05_evaluation/*.md` | Metrics, labeling policies, run reports, report templates, and reported evaluation summaries. |
| Label packets | `docs/05_evaluation/label_packets/<packet>/` | Use [Label Packets README](../05_evaluation/label_packets/README.md) as the L5 packet navigation entry. Lane B packet artifacts, blinded items, packet-local templates, filled labels, and import summaries are evaluation artifacts, not runtime schemas or approvals. |
| Runtime code | `lib/vanta/**/*.ex`, `lib/mix/tasks/vanta/*.ex` | Current Elixir implementation and CLI entry points. Runtime modules and Mix task modules are grouped by engineering responsibility while preserving existing module names and CLI task names. |
| Executable fixtures | `test/fixtures/document_ops/` | ExUnit-consumed fixture mirror. Must stay byte-for-byte synchronized with `docs/04_experiments/fixtures/document_ops/`. |
| ChatGPT Project Knowledge export | `chatgpt_docs/docs/` | Curated mirror of selected source docs. It is not the source of truth and must remain at 25 files or fewer unless the cap changes. |

## Documentation Tree

```text
docs/
  00_manifest/      Governance, routing, decisions, gates, traceability
  01_theory/        Theory source, hypotheses, alternatives, validation review
  02_specs/         Implementable behavior and semantic contracts
  03_schemas/       JSON schemas plus schema impact review documents
  04_experiments/   Benchmark definitions, protocols, fixtures, results
  05_evaluation/    Metrics, labels, reports, label packets
  06_engineering/   Architecture, module plan, repo structure, test strategy
```

The documentation source tree intentionally keeps result provenance in place:

```text
docs/04_experiments/
  fixtures/document_ops/                   Documentation-side fixture source
  results/
    experiment_001/<timestamp>/
    experiment_002/<timestamp>/
    experiment_003/<timestamp>/
    experiment_004/<timestamp>/
    experiment_005/<timestamp>/
    post_stage_1_larger_sample/<timestamp>/
    side_effect_planning/<timestamp>/      Planning artifacts only when present

docs/05_evaluation/
  label_packets/
    post_stage_1_lane_b_20260601_113121/   Active reported Lane B packet
    post_stage_1_lane_b_20260530_141649/   Superseded historical packet
```

The `20260601_113121` Lane A larger controlled sample is the accepted closure
for the named threshold-governed Document Ops Lane A sample only. Historical
Lane A result directories remain provenance records. Label packet directories
remain evaluation artifacts and do not authorize runtime approval, schema
changes, memory writes, irreversible effects, or H1-H5 validation.

The navigation entries for these artifact trees are:

- [Experiment Results README](../04_experiments/results/README.md)
- [Label Packets README](../05_evaluation/label_packets/README.md)

## Artifact Retention Policy

This artifact retention policy documents current tracking and ignore
boundaries. It does not move existing result, fixture, label packet, or runtime
paths.

| Artifact class | Retention rule | Tracking boundary |
| --- | --- | --- |
| Tracked source docs | Keep authored governance, theory, spec, experiment, evaluation, and engineering Markdown under `docs/`. Source docs remain the source of truth over ChatGPT export mirrors. | Tracked unless explicitly generated/local. |
| Tracked schemas | Keep `docs/03_schemas/*.schema.json` and schema navigation documents under L3. Schemas define data contracts; schema impact reviews are review documents only. | Tracked. Do not add enum behavior through retention changes. |
| Tracked summary, closure, and report Markdown | Keep run `summary.md`, `fixture_inventory.md`, evaluation reports, label reports, closure documents, and closure candidates in place, including failed or superseded records. | Tracked when part of result/report provenance. Do not rewrite historical results to create new claims. |
| Tracked required compact run artifacts | Keep compact machine-readable artifacts that are already tracked or explicitly required by a report or closure, such as selected `run.json` files and label packet JSON/JSONL records. | Tracked only when intentionally included. Existing tracked files remain tracked even when a broad ignore pattern would ignore new untracked peers. |
| Ignored raw logs and scratch artifacts | Keep bulky raw traces, scratch JSON, and one-off local run byproducts out of source control unless a later report explicitly elevates a compact artifact. Historical tracked `_logs/` remain provenance and should not be deleted or moved during cleanup. | Ignored/local by default where `.gitignore` applies; do not broaden tracking accidentally. |
| Generated local build artifacts | Keep Mix dependencies, build output, and editor/language-server state local. | Ignored: `/deps/`, `/_build/`, and `/.elixir_ls/`. |
| ChatGPT Project Knowledge export | Keep `chatgpt_docs/` as a local curated mirror capped at 25 files or fewer unless the cap changes. When a source file already mirrored there changes, update the corresponding mirror in the same turn. Do not automatically add new README or policy files unless routing, progress, gate, or source-of-truth needs require it. | Ignored by `/chatgpt_docs`; source remains under `docs/`. |

Current `.gitignore` mapping:

| `.gitignore` entry | Policy interpretation |
| --- | --- |
| `/deps/` | Generated Mix dependencies; local only. |
| `/_build/` | Generated Mix build output; local only. |
| `/.elixir_ls/` | Local editor/language-server artifact; local only. |
| `docs/04_experiments/results/experiment_001/*/raw/` | Experiment 001 raw scratch logs; ignored while compact `run.json` and `summary.md` provenance remains reviewable. |
| `docs/04_experiments/results/*/*/*.json` | Broad guard against accidentally adding unreviewed result JSON. Required compact JSON should be explicitly tracked or explicitly unignored only when a report or closure needs it. |
| `!docs/04_experiments/results/experiment_004/20260506_231941/run.json` | Explicit tracked compact run JSON exception for the Experiment 004 local smoke closure. |
| `!docs/04_experiments/results/experiment_005/20260507_105950/run.json` | Explicit tracked compact run JSON exception for the Experiment 005 local smoke closure. |
| `/chatgpt_docs` | Local ChatGPT Project Knowledge export mirror; synchronize mirrored files when their source changes, but keep source-of-truth status in `docs/`. |

Retention boundaries:

- Historical, failed, superseded, timeout, and partial run directories are
  provenance. Do not delete, rename, or move them during source-tree cleanup.
- Side-effect planning results remain planning-only artifacts. Retention does
  not authorize runtime execution of `COMMITTABLE`, `IRREVERSIBLE`, or
  `MEMORY_WRITE` actions.
- Label packets remain evaluation artifacts. Filled labels, import summaries,
  coordinator-only notes, and redacted packets do not create runtime approval,
  schema expansion, H1-H5 validation, or full Context OS validation.
- New validation claims require measured experiment artifacts plus evaluation
  and manifest closure treatment. Retention alone never validates a hypothesis.

## Runtime Code Layout

The runtime source under `lib/vanta/` is grouped by engineering responsibility
while preserving existing `Vanta.*` module names. The directory split is a
source-layout cleanup only; it does not rename modules, change runtime behavior,
move documentation provenance paths, or authorize new side-effect classes.

```text
lib/
  vanta/
    runtime/
      state_manager.ex
      execution_ir_compiler.ex
      action_executor.ex
      evidence_builder.ex
      verifier_runtime.ex
      commit_controller.ex
      episode_journal.ex
      runtime.ex
      replay_runner.ex
    adapters/
      planner_adapter.ex
      open_ai_planner_adapter.ex
      open_claw_harness.ex
      open_claw_planner_adapter.ex
      open_claw_verifier_adapter.ex
      open_claw_recovery_adapter.ex
      open_claw_context_planner_adapter.ex
    document_ops/
      structured_edit.ex
      fixture_acceptance.ex
    experiments/
      experiment001.ex ... experiment005.ex
      baseline_runner.ex
      blind_retry_runner.ex
      recovery_runner.ex
      recovery_policy.ex
      evaluation_harness.ex
      working_set_compiler.ex
      raw_trace_context_builder.ex
    post_stage1/
      post_stage1_larger_sample.ex
      post_stage1_lane_b_packet.ex
      post_stage1_lane_b_label_results.ex
      post_stage1_side_effect_planning.ex
    support/
      hash.ex
      path_guard.ex
      schema.ex
  mix/tasks/
    vanta/
      experiment001.ex ... experiment005.ex
      post_stage_1_larger_sample.ex
      post_stage_1_lane_b_packet.ex
      post_stage1_lane_b_label_results.ex
      post_stage_1_side_effect_planning.ex
```

`lib/mix/tasks/vanta/` groups the Vanta Mix task source files by CLI namespace.
This is a source-layout cleanup only; existing `Mix.Tasks.Vanta.*` module names,
public `mix vanta.*` task names, and compatibility aliases in `mix.exs` remain
unchanged.

## Fixture Mirror Rule

Document Ops fixtures have two required locations:

```text
docs/04_experiments/fixtures/document_ops/
test/fixtures/document_ops/
```

The docs tree is the documentation-side fixture and provenance mirror. The test
tree is the executable fixture mirror used by ExUnit and Mix tasks. The two
trees must remain byte-for-byte synchronized. `Vanta.FixtureSyncTest` enforces
this by comparing relative file lists and file contents.

## Follow-Up Source Layout

No remaining source-layout follow-up should move
`docs/04_experiments/results/`, `docs/04_experiments/fixtures/`,
`test/fixtures/`, or `docs/05_evaluation/label_packets/` unless a later
accepted repository migration plan explicitly changes provenance path policy.

## Rules

- Theory changes should not directly mutate implementation behavior.
- Schemas define data contracts; specs define behavior.
- Schema impact reviews document schema decisions but do not add enum behavior.
- Experiment results must stay separate from protocols and design docs.
- Historical, superseded, and failed result directories remain provenance.
- Label packets are evaluation artifacts, not runtime schemas or runtime
  approvals.
- Generated artifacts should remain clearly separated from authored source.
- ChatGPT Project Knowledge export files must be synchronized byte-for-byte when
  their source file is included in `chatgpt_docs/`.

## Open Questions

- Should schema files remain documentation-local, or become a packaged runtime
  asset after a later accepted schema governance decision?
