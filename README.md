# Vanta

Vanta 是以 Elixir 實作的 agent runtime 研究原型，研究如何把行動、證據、驗證與提交拆成可檢查、可恢復的執行流程。第一個領域是 Document Ops：以可逆的文件修改觀察副作用、驗證失敗與恢復行為。

```text
state → plan → action → evidence → verify → commit / abort
```

目前實作包括 structured document edits、fixture-local SQLite persistence，以及限定於臨時複製工作區的文件 promotion。專案範圍與權威文件由 [Project Manifest](docs/00_manifest/Project_Manifest.md) 與 [Document Map](docs/00_manifest/Document_Map.md) 定義。

## 原碼閱讀路線

| 步驟 | 入口 | 主要問題 |
| --- | --- | --- |
| 1 | [Runtime.run_task](lib/vanta/runtime/runtime.ex) | 初始化 workspace、state、journal，串接每個 action 及中止條件。 |
| 2 | [Execution IR compiler](lib/vanta/runtime/execution_ir_compiler.ex)、[Action executor](lib/vanta/runtime/action_executor.ex) | 以 schema、side-effect class 與 path guard 約束執行。 |
| 3 | [Evidence builder](lib/vanta/runtime/evidence_builder.ex)、[Verifier](lib/vanta/runtime/verifier_runtime.ex)、[Commit controller](lib/vanta/runtime/commit_controller.ex) | 讓證據和驗證結果決定 commit／abort。 |
| 4 | [Persistence](lib/vanta/persistence/persistence.ex)、[SQLite adapter](lib/vanta/persistence/sqlite_adapter.ex)、[Recovery](lib/vanta/persistence/recovery.ex) | accepted pointers、idempotency、durable intent 與協定邊界恢復。 |
| 5 | [FixtureCommit](lib/vanta/runtime/fixture_commit.ex)、[測試](test/vanta/experiments/fixture_commit_experiment_test.exs) | approval scope、pre/post verification、rollback 與 strict replay。 |

## 保留的實驗結果

| 實驗 | 原始資料與報告 | 結果的適用範圍 |
| --- | --- | --- |
| G9：Persistence and Recovery | [run.json](docs/04_experiments/results/persistence_and_recovery/20260715_114209/run.json)、[Experiment 006](docs/05_evaluation/Experiment_006_Persistence_and_Recovery_Run_Report.md)、[closure](docs/00_manifest/Post_Stage_1_Persistence_v0_Closure.md) | 歷史紀錄為 20/20 個 deterministic protocol-boundary 案例通過。 |
| G10：Fixture-local Committable Execution | [run.json](docs/04_experiments/results/fixture_local_committable_execution/20260716_020716/run.json)、[failure matrix](docs/04_experiments/results/fixture_local_committable_execution/20260716_020716/failure_injection_matrix.md)、[Experiment 007](docs/05_evaluation/Experiment_007_Fixture_Local_Committable_Execution_Run_Report.md)、[closure](docs/00_manifest/Post_Stage_1_Fixture_Local_Committable_v0_Closure.md) | 歷史紀錄為 28/28 案例通過，包含預期拒絕、restart、rollback、replay 等不同條件，不是 28 次成功提交。 |

可從 G10 failure matrix 選 valid approval、missing evidence、同 key 重試與 crash window 案例，對照 `FixtureCommit` 的處理順序。這些結果限於明確標記的 ephemeral copied workspace；沒有涵蓋 OS process kill、斷電、分散式交易或真實外部系統的副作用安全。

## 本地檢查

[mix.exs](mix.exs) 要求 Elixir `~> 1.19`，依賴由 [mix.lock](mix.lock) 記錄。[CI 設定](.github/workflows/ci.yml) 使用 Elixir `1.19.x`／OTP `28.x`；G10 的 [environment manifest](docs/04_experiments/results/fixture_local_committable_execution/20260716_020716/environment_manifest.json) 保留當次 Windows／Elixir `1.19.5`／OTP `28` 環境。

```sh
mix --version
mix deps.get
mix test.fast
```

其他測試群組為 `mix test.docs`、`mix test.tooling`、`mix test.integration` 與 `mix test.full`，覆蓋範圍見 [Testing Strategy](docs/06_engineering/Testing_Strategy.md)。安裝需要取得依賴；編譯與測試會產生本地 build／scratch 檔案。上述命令是執行入口，不代表目前 checkout 已重新通過全部測試。

## 已知限制

[Lane A 報告](docs/05_evaluation/Post_Stage_1_Lane_A_20260601_113121_Run_Report.md) 與 [Context OS pilot 報告](docs/05_evaluation/Post_Stage_1_Context_OS_Evaluation_Pilot_Run_Report.md) 引用的 `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/run.json` 尚未隨庫提供；依賴該檔案的 evaluator／tooling 路徑不能由乾淨 clone 完整重現。Pilot 的部分 controls 為事後 attestation，不是來源 run 原生 metadata。

[Design Theory](docs/01_theory/Design_Theory.md) 提供研究動機，不等於已測得的結論。現有結果不驗證完整 Context OS、H1–H5、learned retrieval、durable memory 或通用 production agent。Repository 目前未附 LICENSE；原始標註與第三方材料的分享範圍仍需依其來源個別確認。
