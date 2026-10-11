# Professor-facing Repository Audit — Vanta

Vanta 有可閱讀的 runtime、schema、受控測試與 G9/G10 結果，適合展示系統設計與失敗處理；目前 clone 的 Lane A 原始結果缺檔，且個人貢獻與授權未確認，因此尚不能宣稱完整可重現或準備完成公開。優先展示資料齊備的 fixture-local persistence / promotion，避免把理論與歷史報告提升成通用 agent 的驗證。

- 審查日期：2026-10-11。
- 審查基準 HEAD：`0aa79a22e1c76178b2b56cbfaa03f6de3dfad03f`。
- 初始工作樹乾淨；本次只新增 README 與本文件。未補寫程式、研究結果、標註或貢獻證據。
- 本文件為展示審查，不改變 [Project Manifest](docs/00_manifest/Project_Manifest.md)、[Document Map](docs/00_manifest/Document_Map.md) 或既有 closure 的權限。

本次 README 與 audit 由 AI 協助整理；這項文件協作不代表原專案的研究或程式貢獻已完成歸屬確認。

## 評分

統一尺度：1 = 入口或證據缺失；2 = 部分具備且有重要限制；3 = 可沿文件核查但有公開前缺口；4 = 易審閱且範圍內可重現；5 = 獨立重現與個人歸屬完整。分數是本次審查判斷，不是研究成績；未執行的命令不計為通過。

| 面向 | 分數 | 本地依據與理由 |
| --- | ---: | --- |
| Readiness | 2/5 | 新 [README](README.md) 提供入口，[mix.exs](mix.exs) / [mix.lock](mix.lock) / [CI](.github/workflows/ci.yml) 提供環境線索。但 [Lane A 來源目錄](docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/) 缺 `run.json`，乾淨 clone 的 evidence-backed tooling 有必要輸入缺口；授權與個人歸屬也未完成。 |
| Readability | 3/5 | [Runtime](lib/vanta/runtime/runtime.ex) 與 [module plan](docs/06_engineering/Runtime_Module_Plan.md) 可逐層追讀，新 README 將關鍵流程串起來。[FixtureCommit](lib/vanta/runtime/fixture_commit.ex) 同時處理 approval、effect、persistence 與 recovery，閱讀成本仍高；本次用導覽保留正常核心。 |
| Verifiability | 2/5 | [G9 結果](docs/04_experiments/results/persistence_and_recovery/20260715_114209/run.json) / [G9 報告](docs/05_evaluation/Experiment_006_Persistence_and_Recovery_Run_Report.md) 與 [G10 結果](docs/04_experiments/results/fixture_local_committable_execution/20260716_020716/run.json) / [G10 報告](docs/05_evaluation/Experiment_007_Fixture_Local_Committable_Execution_Run_Report.md) 都存在；但 [Context OS evaluator test](test/vanta/post_stage1/post_stage1_context_os_evaluation_test.exs) 直接讀取缺少的 Lane A `run.json`。本次只辨識 runtime 版本，未獨立重現測試與研究。 |
| Technical Depth | 4/5 | [Persistence](lib/vanta/persistence/persistence.ex)、[Recovery](lib/vanta/persistence/recovery.ex)、[FixtureCommit](lib/vanta/runtime/fixture_commit.ex) 展示 typed artifacts、hash、logical commit、durable prepared intent、idempotency、失敗恢復與 strict replay；[28-case failure matrix](docs/04_experiments/results/fixture_local_committable_execution/20260716_020716/failure_injection_matrix.md) 可對照。評分針對可審閱的工程內容，不代表安全性或研究假說已獲廣泛驗證。 |
| Individual Contribution | 1/5 | [Manifest](docs/00_manifest/Project_Manifest.md) 與 [mix.exs](mix.exs) 說明專案與依賴，但未提供可核對的本人 / 合作者 / AI / 第三方模組貢獻表。Git author 與檔案存在不足以判定全部工作由申請者完成。 |

## 公開前必須修復的問題

| 優先 | 問題及目前狀態 | 所需處理 |
| --- | --- | --- |
| 必修 | 本 clone 缺 `docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/run.json`，而 [pilot report](docs/05_evaluation/Post_Stage_1_Context_OS_Evaluation_Pilot_Run_Report.md) / [evaluator test](test/vanta/post_stage1/post_stage1_context_os_evaluation_test.exs) 依賴它。[.gitignore](.gitignore) 忽略 results 下多類 JSON，Lane A 沒有對應例外。 | 本次 README 已揭露缺口。公開版本需由作者確認既有 artifact 是否可合法、完整提供；若不提供，就維持歷史報告引用與不可獨立核查的限制。不得重建資料來冒充當次測量。 |
| 必修 | 貢獻歸屬未確認。 | 由作者依既有 commit / 工作紀錄確認本人決策、實作、實驗、標註與 AI 輔助範圍；無來源的部分維持未確認。尤其 [Lane B 報告](docs/05_evaluation/Post_Stage_1_Lane_B_20260601_113121_Label_Report_Skeleton.md) 的 labeler / coordinator 角色不能自行歸給申請者。 |
| 必修 | 本地 tracked files 未找到 LICENSE / LICENCE / NOTICE；程式、報告、資料與第三方引用的再散布條件未確認。 | 作者確認所有權、第三方來源與可公開權利後決定授權方式；本次未自行套用授權。依賴來源見 [mix.exs](mix.exs) / [mix.lock](mix.lock)。 |
| 必修 | 既有通過記錄與當前 clone 的獨立重現未區分。 | README 已分開命令查實與實際執行；提交申請前僅可引用 [G10 closure](docs/00_manifest/Post_Stage_1_Fixture_Local_Committable_v0_Closure.md) 記載的歷史測試。若後續重現，需誠實記錄環境、命令、失敗與範圍；本次未新增研究證據。 |
| 必修 | 公開 artifact 的授權、姓名 / 識別資訊與標註盲化分享範圍未全面核對。 | 由作者依 [label packet](docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121/README.md) 決定可分享範圍並審查現有資料。本次未改 raw labels、coordinator files 或歷史結果，也未完成全 Git 歷史敏感資料掃描。 |

## 可宣稱與不能宣稱

| 可依現有來源宣稱 | 限制 |
| --- | --- |
| 已有閉環 runtime、structured Document Ops 與 fixture-local persistence / promotion 程式。 | 來源：[Runtime](lib/vanta/runtime/runtime.ex)、[structured edit](lib/vanta/document_ops/structured_edit.ex)、[G10 implementation](lib/vanta/runtime/fixture_commit.ex)；不能延伸為通用 production agent。 |
| 既有 G9 報告記載 20/20、G10 報告記載 28/28 deterministic failure-injection cases 通過，且各自有命名 scope closure。 | 來源：[G9 report](docs/05_evaluation/Experiment_006_Persistence_and_Recovery_Run_Report.md)、[G10 closure](docs/00_manifest/Post_Stage_1_Fixture_Local_Committable_v0_Closure.md)；這是 repo 既有結果，本次未重跑。不能宣稱 OS process kill、分散式交易、真實外部副作用安全或生產就緒。 |
| 有 Lane A 與 Context OS pilot 的歷史報告。 | 來源：[Lane A report](docs/05_evaluation/Post_Stage_1_Lane_A_20260601_113121_Run_Report.md)、[pilot report](docs/05_evaluation/Post_Stage_1_Context_OS_Evaluation_Pilot_Run_Report.md)；來源 run 缺檔，不能宣稱本 clone 可完整重現。pilot 部分 controls 為 post-hoc attestation，不能當成 source-run-native metadata 或純 model-only comparison。 |

不能宣稱 H1–H5、完整 Context OS、learned retrieval、durable memory、一般 `COMMITTABLE` / `IRREVERSIBLE` / `MEMORY_WRITE` 安全性已驗證，或全部成果均由申請者獨立完成。這些邊界已由 [Manifest](docs/00_manifest/Project_Manifest.md) 與 [G10 closure](docs/00_manifest/Post_Stage_1_Fixture_Local_Committable_v0_Closure.md) 明列。

## 核查與展示方式

本次已執行 `git status --short`、`git rev-parse HEAD` 與 `mix --version`：初始工作樹乾淨，Mix `1.19.5` / Erlang OTP `28` 可辨識。亦核對 G9/G10 結果檔、G10 environment manifest 與 Lane A 來源缺檔。未執行 `mix deps.get`、編譯、任何測試、model / OpenClaw 呼叫或新實驗；README 命令只是依 [mix.exs](mix.exs) / [Testing Strategy](docs/06_engineering/Testing_Strategy.md) 查實。

展示時先用 [G10 failure matrix](docs/04_experiments/results/fixture_local_committable_execution/20260716_020716/failure_injection_matrix.md) 選 valid approval、missing evidence、同 key 重試、crash window 各一例，對照 [FixtureCommit](lib/vanta/runtime/fixture_commit.ex) 的檢查與恢復順序，再說明單機 copied-fixture scope。這條閱讀路線只整理既有證據，不新增 demo、截圖、結果或核心重構。
