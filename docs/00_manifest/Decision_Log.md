# Decision Log

## Purpose

Record documentation and research decisions that materially affect scope, interfaces, or interpretation.

| Date | Decision | Rationale | Status |
| --- | --- | --- | --- |
| 2026-05-01 | Use a 7-directory documentation tree with `00_manifest` as governance/meta layer. | The requested system is sometimes described as 6 layers, but the actual tree includes the manifest layer. | Accepted |
| 2026-05-01 | Preserve original Chinese source files unchanged. | They are canonical source material for translation and future comparison. | Accepted |
| 2026-05-01 | Treat theory as research basis, not implementation authority. | Implementation must pass through specs, schemas, experiments, and evaluation. | Accepted |
| 2026-05-01 | Use JSON Schema draft-07 skeletons with `schema_version` as the only required field initially. | The runtime fields are not yet empirically validated or fully specified. | Accepted |
| 2026-05-01 | Accept `Stage_0_Boundary_Lock.md` as the Stage 0 conceptual boundary gate. | The boundary rules were previously scattered across theory, specs, non-goals, and engineering notes. | Accepted |
| 2026-05-01 | Add a minimal `working_set.schema.json` while deferring full Context OS implementation. | Stage 0 needs a data-contract boundary for working sets, but Phase 5 remains the implementation point for Context OS optimization. | Accepted |
| 2026-05-02 | Use Document Ops as the first Stage 1 MVP vertical domain. | Document operations provide reversible, inspectable, provenance-friendly tasks without irreversible external side effects. | Accepted |
| 2026-05-02 | Promote Stage 1 runtime schemas from skeletons to required-field contracts. | Phase 1 runtime artifacts and fixtures need stable required fields before Experiment 001 can run. | Accepted |
| 2026-05-02 | Implement Phase 1 runtime skeleton in Elixir/Mix. | The first runtime should be small, deterministic, and testable against JSON artifacts and fixture-local actions. | Accepted |
| 2026-05-02 | Mirror Document Ops fixtures under `docs/04_experiments/fixtures/` and `test/fixtures/`. | Research-readable fixtures and executable test fixtures must remain synchronized while serving different consumers. | Accepted |
| 2026-05-02 | Defer Experiment 001 execution until Stage 1 contracts, fixtures, runtime skeleton, and tests are in place. | The repository must not report validation results before measured experiment execution. | Accepted |
| 2026-05-02 | Add an env-gated OpenAI LLM action-sequence baseline for Experiment 001. | The baseline should compare direct execution against the runtime governance spine while keeping Verifier v0 deterministic and rule-based. | Accepted |
| 2026-05-02 | Treat negative Document Ops fixtures as benchmark and test cases. | Stage 1 must measure rejection, path guard, and fixture-specific verifier behavior, not only successful commits. | Accepted |
| 2026-05-02 | Track compact Experiment 001 `run.json` and `summary.md`, while ignoring raw scratch logs. | Measured runs should be reviewable and machine-readable without committing bulky transient artifacts. | Accepted |
| 2026-05-03 | Add an OpenClaw local agent harness planner adapter for Experiment 001 candidate runs. | The local environment can authenticate through OpenClaw `openai-codex`; results must be labeled as OpenClaw harness runs, not pure model-only baselines. | Accepted |
| 2026-05-03 | Treat OpenClaw `openai-codex/gpt-5.4-mini` as the candidate canonical local LLM baseline for Experiment 001 smoke runs. | The latest measured local OpenClaw run completed the seven-fixture smoke gate, while still remaining an OpenClaw harness baseline rather than a pure model-only or statistically validated canonical baseline. | Accepted |
| 2026-05-03 | Close Stage 1 and Experiment 001 as `Closed: local smoke completed`. | The measured OpenClaw candidate canonical local baseline run satisfied the Stage 1 local smoke gate; broader baselines, larger samples, false accept / false reject analysis, and audit completeness remain deferred work. | Accepted |
| 2026-05-04 | Close Phase 2 and Experiment 002 verifier hardening as `Closed: local smoke completed`. | The `20260504_205316` run shows the rules-first structured verifier corrected structured-arm false accept in the seven-fixture local smoke; this is not broad validation of H2. | Accepted |
| 2026-05-04 | Close Phase 3 and Experiment 003 journal/replay audit as `Closed: local smoke completed`. | The `20260504_215304` run shows treatment `commit_integrity_score`, `replay_consistency`, and `audit_completeness` all at `1.0` on the seven-fixture local smoke; this is not broad validation of H5. | Accepted |
| 2026-05-05 | Add Phase 4 Targeted Recovery fixtures, recovery decision schema, and matched-budget Experiment 004 protocol. | H4 requires direct comparison against blind retry under matched compute; rollback failure, audit gap, and compensable-action fixtures provide controlled recovery cases without executing irreversible external actions. | Accepted |
| 2026-05-06 | Close Phase 4 and Experiment 004 as `Closed: local smoke completed`. | The `20260506_231941` matched-budget OpenClaw local harness run shows targeted recovery succeeded on the three controlled recovery fixtures while blind retry recovered none; this is not broad validation of H4. | Accepted |
| 2026-05-07 | Gate Phase 5 as `Working Set Compiler v0` only. | H3 requires a bounded raw-trace comparison and Context OS metrics before any broader claim; Phase 5 must produce schema-valid, reference-backed working sets without full Context OS, memory writes, or raw log dumps. | Accepted |
| 2026-05-07 | Close Phase 5 and Experiment 005 as `Closed: local smoke completed`. | The `20260507_105950` OpenClaw local harness run shows `Working Set Compiler v0` produced schema-valid, budget-adherent, provenance-complete working sets on five controlled Document Ops long-context fixtures and reduced fixture-required context omission compared with bounded raw trace; this is not broad validation of H3 or full Context OS. | Accepted |
| 2026-05-09 | Accept the post-Stage-1 advancement gate. | The five local smoke closures leave recurring questions about larger samples, human labels, thresholds, baseline identity, and broader scope; these are now tracked as explicit gate items rather than open-ended advancement permission. | Accepted |

## Post-Stage-1 Gate Tracking

| Prior open decision | Gate item |
| --- | --- |
| Minimum benchmark size beyond the current local Document Ops fixtures. | `PS1-G1` in [Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md). |
| Human labeling budget and annotation rules. | `PS1-G3` and `PS1-G4` in [Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md). |
| Metric thresholds for broader MVP acceptance beyond the Stage 1 local smoke gate. | `PS1-G2` in [Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md). |
| Whether the candidate canonical local baseline should be promoted, replaced, or kept alongside Responses. | `PS1-G5` in [Post-Stage-1 Advancement Gate](Post_Stage_1_Advancement_Gate.md). |
