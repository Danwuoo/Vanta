# Vanta

Vanta 是以 Elixir 實作的 agent runtime 研究原型，將 `state → plan → action → evidence → verify → commit / abort` 拆成可檢查的資料契約與執行流程。目前最適合展示的是受控 Document Ops、fixture-local SQLite persistence 與複製 fixture 內的文件 promotion；範圍與既有驗收由 [Project Manifest](docs/00_manifest/Project_Manifest.md) 定義。

申請審閱入口：[Professor-facing Repository Audit](PROFESSOR_AUDIT.md)。這份 README 是閱讀導覽；治理、驗收與研究宣稱仍依 [Document Map](docs/00_manifest/Document_Map.md) 指向的原始文件。

## 教授閱讀路線

1. 先看 [Audit](PROFESSOR_AUDIT.md) 的公開前缺口與可宣稱範圍。
2. 看 [Experiment 006 報告](docs/05_evaluation/Experiment_006_Persistence_and_Recovery_Run_Report.md) 和 [Experiment 007 報告](docs/05_evaluation/Experiment_007_Fixture_Local_Committable_Execution_Run_Report.md)，再對照各自的結果與失敗注入案例。
3. 沿下方程式導覽看 `run_task` 如何把 action、evidence、verifier、journal 和 persistence 接起來。
4. 若要理解研究動機，再讀 [Design Theory](docs/01_theory/Design_Theory.md)；理論假說不能當成已測得的結論。

## 目前實作與證據邊界

| 範圍 | 已存在的來源 | 審閱時應如何解讀 |
| --- | --- | --- |
| 閉環 runtime / structured edit | [Runtime](lib/vanta/runtime/runtime.ex)、[structured edit](lib/vanta/document_ops/structured_edit.ex) | 有程式與受控 fixtures，並非通用生產 agent。 |
| Fixture-Local SQLite Persistence v0 | [20-case 結果](docs/04_experiments/results/persistence_and_recovery/20260715_114209/run.json)、[closure](docs/00_manifest/Post_Stage_1_Persistence_v0_Closure.md) | 既有 deterministic protocol-boundary failure injection；未測 OS process kill、斷電或分散式交易。 |
| Fixture-Local COMMITTABLE Document Promotion v0 | [28-case 結果](docs/04_experiments/results/fixture_local_committable_execution/20260716_020716/run.json)、[closure](docs/00_manifest/Post_Stage_1_Fixture_Local_Committable_v0_Closure.md) | 只允許明確標記的 ephemeral copied workspace；不能延伸到真實使用者文件或外部系統。 |
| Lane A / Context OS planning | [Lane A 報告](docs/05_evaluation/Post_Stage_1_Lane_A_20260601_113121_Run_Report.md)、[Context OS pilot 報告](docs/05_evaluation/Post_Stage_1_Context_OS_Evaluation_Pilot_Run_Report.md) | 報告存在，但本 clone 缺少來源 Lane A `run.json`；來源鏈尚不能完整核查。完整 Context OS、H1–H5 與 production readiness 均未因此成立。 |

本 clone 的 `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/` 只有摘要與 fixture inventory，缺少報告及 evaluator 引用的 `run.json`。這是可重現性缺口；本次整理未重建或改寫任何歷史證據。詳細影響見 [Audit](PROFESSOR_AUDIT.md)。

## 安裝與本地檢查

[mix.exs](mix.exs) 要求 Elixir `~> 1.19`，依賴版本由 [mix.lock](mix.lock) 記錄。既有 [CI](.github/workflows/ci.yml) 使用 Elixir `1.19.x` / Erlang OTP `28.x`；[G10 environment manifest](docs/04_experiments/results/fixture_local_committable_execution/20260716_020716/environment_manifest.json) 記錄 Elixir `1.19.5` / OTP `28` / Windows。

以下命令已對照 `mix.exs`、CI 與 [Testing Strategy](docs/06_engineering/Testing_Strategy.md)，本次未安裝依賴、編譯或執行測試。`mix deps.get` 需要取得套件，編譯與測試會產生本地 build / scratch 檔案。

```text
mix --version
mix deps.get
mix test.fast
```

進階檢查分為 `mix test.docs`、`mix test.tooling`、`mix test.integration`、`mix test.full`；詳細覆蓋由 Testing Strategy 定義。來源 Lane A artifact 缺檔會阻礙依賴它的 evaluator / tooling 路徑，因此不能承諾乾淨 clone 的全套測試已通過。模型與 OpenClaw 的歷史實驗需要額外環境，並非初次審閱的必要步驟。

## 關鍵程式導覽

| 閱讀順序 | 入口 | 要觀察的問題 |
| --- | --- | --- |
| 1 | [Runtime.run_task](lib/vanta/runtime/runtime.ex) | workspace、action sequence、state / journal 初始化，以及每個 action 的中止條件。 |
| 2 | [Execution IR compiler](lib/vanta/runtime/execution_ir_compiler.ex)、[Action executor](lib/vanta/runtime/action_executor.ex) | action 如何受 schema、side-effect class 與 path guard 限制。 |
| 3 | [Evidence builder](lib/vanta/runtime/evidence_builder.ex)、[Verifier](lib/vanta/runtime/verifier_runtime.ex)、[Commit controller](lib/vanta/runtime/commit_controller.ex) | evidence 與 verifier 決定如何影響 commit / abort。 |
| 4 | [Persistence](lib/vanta/persistence/persistence.ex)、[SQLite adapter](lib/vanta/persistence/sqlite_adapter.ex)、[Recovery](lib/vanta/persistence/recovery.ex) | accepted pointers、idempotency、durable intent 與 crash-window recovery。 |
| 5 | [FixtureCommit](lib/vanta/runtime/fixture_commit.ex)、[對應測試](test/vanta/experiments/fixture_commit_experiment_test.exs) | approval scope、pre/post verification、rollback 與 strict replay 的邊界。 |

本次只增加導覽與審查文件。研究結果、schemas、程式、fixtures、測試與治理文件均保留原樣；個人、AI 與第三方貢獻歸屬及授權仍待作者確認。
