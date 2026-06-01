defmodule Vanta.PostStage1LaneBPacket do
  @moduledoc """
  Builds and checks the post-Stage-1 Lane B blinded label packet.
  """

  @default_run_timestamp "20260601_113121"
  @label_policy_version "PS1-LB-LABEL-001"
  @metric_policy_version "PS1-LA-METRIC-001"
  @context_gate_policy_version "PS1-LC-CTX-GATE-001"
  @sample_frame "PS1-LA-SAMPLE-002"
  @experiment_id "post_stage_1_larger_sample"
  @not_yet_run "Not yet run"

  @evidence_sample [
    {"docops_read_traceability_001", "traceability_extraction"},
    {"docops_struct_contract_fail_001", "terminology_consistency"},
    {"docops_simulate_patch_001", "simulated_patch_and_diff"},
    {"docops_struct_apply_reversible_001", "reversible_edit_and_commit"},
    {"docops_struct_selector_missing_001", "invalid_action_and_path_guard"},
    {"docops_wrong_diff_001", "evidence_and_verifier_challenge"},
    {"docops_rollback_failure_001", "journal_replay_and_recovery"},
    {"docops_ws_evidence_packet_001", "working_set_long_context"}
  ]

  @working_set_task_ids ~w(
    docops_ws_evidence_packet_001
    docops_ws_irrelevant_context_001
    docops_ws_omission_trap_001
    docops_ws_recovery_context_001
    docops_ws_traceability_long_001
    docops_ps1_ws_structured_edit_context_001
  )

  @redacted_task_oracle_fields ~w(
    required_refs
    relevant_refs
    irrelevant_refs
    omission_trap_refs
    expected_runtime_status
    expected_label_source
    expected_failure_labels
    expected_recovery_policy
    expected_failure_label
  )

  @forbidden_packet_keys @redacted_task_oracle_fields ++ ~w(role description required)

  def default_run_timestamp, do: @default_run_timestamp

  def build(opts \\ []) do
    config = normalize_opts(opts)

    with :ok <- ensure_sources(config),
         {:ok, run} <- load_json(config.run_json_abs),
         :ok <- validate_run_source(run, config),
         {:ok, redacted_task_packets} <- build_redacted_task_packets(config),
         {:ok, evidence_items} <- build_evidence_items(run, config),
         {:ok, working_set_items} <- build_working_set_items(run, config) do
      packet = %{
        opts: config,
        packet_manifest: packet_manifest(config, run, evidence_items, working_set_items),
        readme: packet_readme(config),
        redacted_task_packets: redacted_task_packets,
        evidence_sufficiency_items: evidence_items,
        working_set_context_items: working_set_items,
        adjudication_placeholders:
          adjudication_placeholders(config, evidence_items, working_set_items),
        label_report_skeleton: label_report_skeleton(config)
      }

      {:ok, packet}
    end
  end

  def generate(opts \\ []) do
    with {:ok, packet} <- build(opts) do
      config = packet.opts
      File.mkdir_p!(config.out_abs)
      File.mkdir_p!(Path.join(config.out_abs, "redacted_task_packets"))

      write_text!(Path.join(config.out_abs, "README.md"), packet.readme)
      write_json!(Path.join(config.out_abs, "packet_manifest.json"), packet.packet_manifest)

      Enum.each(packet.redacted_task_packets, fn {task_id, task_packet} ->
        write_json!(
          Path.join([config.out_abs, "redacted_task_packets", "#{task_id}.json"]),
          task_packet
        )
      end)

      write_jsonl!(
        Path.join(config.out_abs, "evidence_sufficiency_items.jsonl"),
        packet.evidence_sufficiency_items
      )

      write_jsonl!(
        Path.join(config.out_abs, "working_set_context_items.jsonl"),
        packet.working_set_context_items
      )

      write_json!(
        Path.join(config.out_abs, "adjudication_placeholders.json"),
        packet.adjudication_placeholders
      )

      File.mkdir_p!(Path.dirname(config.label_report_abs))
      write_text!(config.label_report_abs, packet.label_report_skeleton)

      {:ok,
       %{
         packet_id: packet.packet_manifest["packet_id"],
         packet_dir: config.out_path,
         label_report_skeleton: config.label_report_path,
         evidence_item_count: length(packet.evidence_sufficiency_items),
         working_set_item_count: length(packet.working_set_context_items)
       }}
    end
  end

  def check(opts \\ []) do
    with {:ok, expected} <- build(opts),
         {:ok, actual} <- load_existing_packet(expected.opts, packet_task_ids()) do
      errors =
        []
        |> require_equal(
          "packet_manifest.json",
          actual.packet_manifest,
          expected.packet_manifest
        )
        |> require_equal(
          "evidence_sufficiency_items.jsonl",
          actual.evidence_sufficiency_items,
          expected.evidence_sufficiency_items
        )
        |> require_equal(
          "working_set_context_items.jsonl",
          actual.working_set_context_items,
          expected.working_set_context_items
        )
        |> require_equal(
          "adjudication_placeholders.json",
          actual.adjudication_placeholders,
          expected.adjudication_placeholders
        )
        |> require_equal(
          "redacted_task_packets",
          actual.redacted_task_packets,
          expected.redacted_task_packets
        )
        |> check_required_text(
          "README.md",
          actual.readme,
          [expected.opts.run_json_path, expected.opts.run_report_path, expected.opts.closure_path]
        )
        |> check_required_text(
          "label report skeleton",
          actual.label_report_skeleton,
          [
            expected.opts.run_json_path,
            expected.opts.run_report_path,
            expected.opts.closure_path,
            @not_yet_run
          ]
        )
        |> check_packet_shape(actual)
        |> check_redaction(actual)
        |> check_not_yet_run_labels(actual)
        |> check_selector_repair_item(actual)

      if errors == [] do
        {:ok,
         %{
           packet_id: expected.packet_manifest["packet_id"],
           packet_dir: expected.opts.out_path,
           evidence_item_count: length(actual.evidence_sufficiency_items),
           working_set_item_count: length(actual.working_set_context_items),
           status: "ok"
         }}
      else
        {:error, Enum.reverse(errors)}
      end
    end
  end

  defp normalize_opts(opts) do
    cwd = Keyword.get(opts, :cwd, File.cwd!())
    run_timestamp = Keyword.get(opts, :run_timestamp, @default_run_timestamp)
    out = Keyword.get(opts, :out, default_packet_dir(run_timestamp))
    fixtures = Keyword.get(opts, :fixtures, "docs/04_experiments/fixtures/document_ops")
    run_json = Keyword.get(opts, :run_json, default_run_json(run_timestamp))

    run_report =
      Keyword.get(
        opts,
        :run_report,
        "docs/05_evaluation/Post_Stage_1_Lane_A_#{run_timestamp}_Run_Report.md"
      )

    closure =
      Keyword.get(
        opts,
        :closure,
        "docs/00_manifest/Post_Stage_1_Lane_A_#{run_timestamp}_Closure.md"
      )

    label_report =
      Keyword.get(
        opts,
        :label_report,
        "docs/05_evaluation/Post_Stage_1_Lane_B_#{run_timestamp}_Label_Report_Skeleton.md"
      )

    %{
      cwd: cwd,
      run_timestamp: run_timestamp,
      packet_date: packet_date(run_timestamp),
      packet_id: packet_id(run_timestamp),
      out_abs: Path.expand(out, cwd),
      out_path: display_path(out, cwd),
      fixtures_abs: Path.expand(fixtures, cwd),
      fixtures_path: display_path(fixtures, cwd),
      run_json_abs: Path.expand(run_json, cwd),
      run_json_path: display_path(run_json, cwd),
      summary_abs: Path.expand(Path.join(Path.dirname(run_json), "summary.md"), cwd),
      summary_path: display_path(Path.join(Path.dirname(run_json), "summary.md"), cwd),
      fixture_inventory_abs:
        Path.expand(Path.join(Path.dirname(run_json), "fixture_inventory.md"), cwd),
      fixture_inventory_path:
        display_path(Path.join(Path.dirname(run_json), "fixture_inventory.md"), cwd),
      run_report_abs: Path.expand(run_report, cwd),
      run_report_path: display_path(run_report, cwd),
      closure_abs: Path.expand(closure, cwd),
      closure_path: display_path(closure, cwd),
      label_report_abs: Path.expand(label_report, cwd),
      label_report_path: display_path(label_report, cwd),
      closure_status: closure_status(Path.expand(closure, cwd))
    }
  end

  defp default_packet_dir(run_timestamp) do
    "docs/05_evaluation/label_packets/post_stage_1_lane_b_#{run_timestamp}"
  end

  defp default_run_json(run_timestamp) do
    "docs/04_experiments/results/post_stage_1_larger_sample/#{run_timestamp}/run.json"
  end

  defp ensure_sources(config) do
    [
      {config.run_json_abs, "run JSON"},
      {config.summary_abs, "run summary"},
      {config.fixture_inventory_abs, "fixture inventory"},
      {config.run_report_abs, "run report"},
      {config.closure_abs, "closure document"},
      {config.fixtures_abs, "fixture root"}
    ]
    |> Enum.reduce([], fn {path, label}, errors ->
      if File.exists?(path),
        do: errors,
        else: ["missing #{label}: #{display_path(path, config.cwd)}" | errors]
    end)
    |> case do
      [] -> :ok
      errors -> {:error, Enum.reverse(errors)}
    end
  end

  defp validate_run_source(run, config) do
    checks = [
      {"experiment_id", run["experiment_id"], @experiment_id},
      {"sample_frame_id", run["sample_frame_id"], @sample_frame},
      {"metric_policy_version", run["metric_policy_version"], @metric_policy_version},
      {"threshold_status", run["threshold_status"], "pass_acceptance_candidate"}
    ]

    errors =
      checks
      |> Enum.reduce([], fn {field, actual, expected}, errors ->
        if actual == expected do
          errors
        else
          ["source run #{field} is #{inspect(actual)}, expected #{inspect(expected)}" | errors]
        end
      end)
      |> then(fn errors ->
        if run["status"] == "completed" do
          errors
        else
          ["source run status is #{inspect(run["status"])}, expected \"completed\"" | errors]
        end
      end)
      |> then(fn errors ->
        if is_list(run["tasks"]) and length(run["tasks"]) == 48 do
          errors
        else
          ["source run task count is not 48" | errors]
        end
      end)
      |> then(fn errors ->
        if config.closure_status == "accepted_by_closure" do
          errors
        else
          [
            "closure status is #{inspect(config.closure_status)}, expected \"accepted_by_closure\""
            | errors
          ]
        end
      end)

    if errors == [], do: :ok, else: {:error, Enum.reverse(errors)}
  end

  defp build_redacted_task_packets(config) do
    packet_task_ids()
    |> Enum.reduce_while({:ok, %{}}, fn task_id, {:ok, packets} ->
      task_path = Path.join([config.fixtures_abs, task_id, "task.json"])

      case load_json(task_path) do
        {:ok, task} ->
          {:cont, {:ok, Map.put(packets, task_id, redact_task(task, task_path, config))}}

        {:error, errors} ->
          {:halt, {:error, errors}}
      end
    end)
  end

  defp redact_task(task, task_path, config) do
    input_artifacts =
      task
      |> Map.get("input_artifacts", [])
      |> Enum.map(&Map.drop(&1, ["role", "description"]))

    removed_oracle_fields =
      Enum.filter(@redacted_task_oracle_fields, &Map.has_key?(task, &1))

    task
    |> Map.drop(@redacted_task_oracle_fields)
    |> Map.put("input_artifacts", input_artifacts)
    |> Map.put("redaction", %{
      "removed_fields" =>
        ["input_artifacts.role", "input_artifacts.description"] ++ removed_oracle_fields,
      "reason" =>
        "Primary Lane B labelers must not see fixture oracle role fields before label freeze.",
      "source_task_path" => display_path(task_path, config.cwd)
    })
  end

  defp build_evidence_items(run, config) do
    @evidence_sample
    |> Enum.with_index(1)
    |> Enum.reduce_while({:ok, []}, fn {{task_id, stratum}, index}, {:ok, items} ->
      case evidence_item(run, config, task_id, stratum, index) do
        {:ok, item} -> {:cont, {:ok, items ++ [item]}}
        {:error, errors} -> {:halt, {:error, errors}}
      end
    end)
  end

  defp evidence_item(run, config, task_id, expected_stratum, index) do
    with {:ok, task} <- find_task(run, task_id),
         :ok <- ensure_stratum(task, task_id, expected_stratum),
         {:ok, treatment} <- required_map(task, ["runtime_governance", "treatment"], task_id),
         {:ok, evidence_packet} <-
           first_item(treatment["evidence_packets"], "#{task_id} evidence"),
         {:ok, verifier_output} <-
           first_item(treatment["verifier_outputs"], "#{task_id} verifier"),
         {:ok, step} <-
           first_item(get_in(treatment, ["journal", "steps"]), "#{task_id} journal step"),
         {:ok, journal} <- required_map(treatment, ["journal"], task_id) do
      {:ok,
       %{
         "packet_id" => "#{packet_prefix(config)}-es-#{pad3(index)}",
         "label_status" => @not_yet_run,
         "metric_targets" => ["evidence_sufficiency_score"],
         "review_mode" => "double_human_adjudicated",
         "task_id" => task_id,
         "stratum" => expected_stratum,
         "task_packet_path" => redacted_task_packet_path(config, task_id),
         "source_artifact_dir" => source_artifact_dir(config, task_id),
         "evidence_packet" => compact_evidence_packet(evidence_packet),
         "action_under_review" => compact_action_under_review(step),
         "verifier_output" => compact_verifier_output(verifier_output),
         "commit_or_reject_record" => compact_commit_record(journal),
         "primary_label_fields" => evidence_label_fields(),
         "adjudication_status" => @not_yet_run
       }}
    end
  end

  defp build_working_set_items(run, config) do
    @working_set_task_ids
    |> Enum.with_index(1)
    |> Enum.reduce_while({:ok, []}, fn {task_id, index}, {:ok, items} ->
      case working_set_task_items(run, config, task_id, index) do
        {:ok, task_items} -> {:cont, {:ok, items ++ task_items}}
        {:error, errors} -> {:halt, {:error, errors}}
      end
    end)
  end

  defp working_set_task_items(run, config, task_id, index) do
    with {:ok, task} <- find_task(run, task_id),
         :ok <- ensure_stratum(task, task_id, "working_set_long_context"),
         {:ok, working_set} <- required_map(task, ["working_set"], task_id),
         {:ok, baseline} <- required_map(working_set, ["baseline"], task_id),
         {:ok, treatment} <- required_map(working_set, ["treatment"], task_id) do
      inventory = candidate_ref_inventory(working_set)

      arms = [
        {"context_arm_A", baseline},
        {"context_arm_B", treatment}
      ]

      {:ok,
       Enum.map(arms, fn {blinded_arm, arm_result} ->
         context = arm_result["context"] || %{}
         selected_ids = selected_ref_ids(context)

         %{
           "packet_id" => "#{packet_prefix(config)}-ws-#{pad3(index)}-#{blinded_arm}",
           "label_status" => @not_yet_run,
           "metric_targets" => ["context_omission_error_rate", "working_set_relevance_score"],
           "review_mode" => "double_human_adjudicated",
           "task_id" => task_id,
           "blinded_arm" => blinded_arm,
           "context_artifact_id" => context_artifact_id(context),
           "task_packet_path" => redacted_task_packet_path(config, task_id),
           "source_artifact_dir" => source_artifact_dir(config, task_id),
           "candidate_ref_inventory" => inventory,
           "selected_ref_ids" => selected_ids,
           "omitted_ref_ids_visible_as_context_absent" =>
             omitted_visible_ref_ids(inventory, selected_ids),
           "token_budget" => token_budget(context),
           "primary_label_fields" => working_set_label_fields(),
           "adjudication_status" => @not_yet_run
         }
       end)}
    end
  end

  defp packet_manifest(config, run, evidence_items, working_set_items) do
    %{
      "packet_id" => config.packet_id,
      "packet_status" => "prepared_for_labeling",
      "label_collection_status" => @not_yet_run,
      "label_policy_version" => @label_policy_version,
      "source_run" => %{
        "experiment_id" => run["experiment_id"],
        "sample_frame" => run["sample_frame_id"],
        "run_timestamp" => config.run_timestamp,
        "run_status" => run["status"],
        "threshold_status" => run["threshold_status"],
        "closure_status" => config.closure_status,
        "run_json_path" => config.run_json_path,
        "summary_path" => config.summary_path,
        "fixture_inventory_path" => config.fixture_inventory_path,
        "run_report_path" => config.run_report_path,
        "closure_path" => config.closure_path
      },
      "supersedes" => supersedes(config),
      "artifact_paths" => artifact_paths(config),
      "metric_scope" => %{
        "evidence_sufficiency_score" => %{
          "item_count" => length(evidence_items),
          "review_mode" => "double_human_adjudicated",
          "label_source" => "human",
          "label_status" => @not_yet_run
        },
        "context_omission_error_rate" => %{
          "item_count" => length(working_set_items),
          "review_mode" => "double_human_adjudicated",
          "label_source" => "human",
          "label_status" => @not_yet_run
        },
        "working_set_relevance_score" => %{
          "item_count" => length(working_set_items),
          "review_mode" => "double_human_adjudicated",
          "label_source" => "human",
          "label_status" => @not_yet_run
        }
      },
      "candidate_sample_selection" => %{
        "evidence_sufficiency_score" =>
          "One treatment evidence unit from each major Lane A stratum, including the repaired selector-missing rejection artifact and one working-set long-context fixture.",
        "context_omission_error_rate" =>
          "All six working_set_long_context tasks from the accepted source run, with two blinded context arms per task.",
        "working_set_relevance_score" =>
          "Same twelve working-set/context items used for omission labeling."
      },
      "blinding_boundary" => blinding_boundary(),
      "adjudication" => %{
        "status" => @not_yet_run,
        "record_path" => artifact_paths(config)["adjudication_placeholders"],
        "required_triggers" => [
          "any reviewer marks needs_review",
          "ordinal labels differ by two or more levels",
          "evidence labels split across 0-2 versus 3-4",
          "reviewers disagree on task_critical, critical_omission, harmful, or metric denominator"
        ]
      },
      "claim_boundary" => %{
        "allowed_before_labels" =>
          "prepared blinded Lane B label packet from the accepted Lane A closure run",
        "disallowed_before_labels" => [
          "human-labeled broader evaluation evidence",
          "new accepted_by_closure status beyond the Lane A source closure",
          "H1-H5 validation",
          "full Context OS validation",
          "production readiness",
          "runtime approval or human-in-the-loop verifier claim"
        ]
      }
    }
  end

  defp artifact_paths(config) do
    %{
      "packet_readme" => path_join(config.out_path, "README.md"),
      "redacted_task_packets" =>
        ensure_trailing_slash(path_join(config.out_path, "redacted_task_packets")),
      "evidence_sufficiency_items" =>
        path_join(config.out_path, "evidence_sufficiency_items.jsonl"),
      "working_set_context_items" =>
        path_join(config.out_path, "working_set_context_items.jsonl"),
      "adjudication_placeholders" => path_join(config.out_path, "adjudication_placeholders.json"),
      "label_report_skeleton" => config.label_report_path
    }
  end

  defp supersedes(%{run_timestamp: @default_run_timestamp}) do
    %{
      "packet_id" => "PS1-LB-PACKET-20260530-141649-BATCH-001",
      "packet_path" => "docs/05_evaluation/label_packets/post_stage_1_lane_b_20260530_141649/",
      "reason" =>
        "The prior packet was prepared from a non-accepted Lane A run whose selector-missing item contained the pre-repair committed artifact. No labels had been collected, so the active packet is rebuilt from the accepted closure run."
    }
  end

  defp supersedes(_config), do: nil

  defp blinding_boundary do
    %{
      "visible_to_primary_labelers" => [
        "item JSONL records in this packet",
        "redacted task packet paths and fixture input artifact paths referenced by each item",
        "redacted candidate-ref inventories without fixture oracle role fields",
        "blinded context arm names context_arm_A and context_arm_B",
        "evidence packet, action, verifier output, and journal fields copied into evidence item records"
      ],
      "withheld_until_label_freeze" => [
        "fixture oracle role fields required_refs, relevant_refs, irrelevant_refs, and omission_trap_refs",
        "expected_runtime_status and expected_label_source",
        "expected failure labels",
        "original input_artifacts.role and input_artifacts.description fields from fixture task.json files",
        "task success flags from the source run",
        "aggregate Lane A metric values for the item under review",
        "context arm identity mapping from blinded arm name to baseline or treatment",
        "post-run focused repair notes when judging the measured artifact"
      ],
      "coordinator_only_before_label_freeze" => [
        "source run.json",
        "source summary.md",
        "source fixture_inventory.md",
        "original fixture task.json files",
        "Lane A run report",
        "Lane A closure"
      ],
      "fixture_oracle_exposure_for_adjudication" =>
        "Allowed only after primary labels are frozen and must be recorded per adjudication record."
    }
  end

  defp adjudication_placeholders(config, evidence_items, working_set_items) do
    evidence_ids = Enum.map(evidence_items, & &1["packet_id"])
    working_set_ids = Enum.map(working_set_items, & &1["packet_id"])

    %{
      "packet_id" => config.packet_id,
      "status" => @not_yet_run,
      "label_policy_version" => @label_policy_version,
      "review_mode" => "double_human_adjudicated",
      "evidence_sufficiency_score" => %{
        "item_ids" => evidence_ids,
        "adjudication_required_when" => [
          "any reviewer marks needs_review",
          "raw labels differ by two or more levels",
          "reviewers split across 0-2 versus 3-4 acceptability boundary"
        ],
        "records" => [],
        "unresolved_needs_review_count" => @not_yet_run
      },
      "context_omission_error_rate" => %{
        "item_ids" => working_set_ids,
        "adjudication_required_when" => [
          "reviewers disagree on task_critical",
          "reviewers disagree on critical_omission",
          "reviewers disagree on denominator",
          "any reviewer marks needs_review"
        ],
        "records" => [],
        "unresolved_needs_review_count" => @not_yet_run
      },
      "working_set_relevance_score" => %{
        "item_ids" => working_set_ids,
        "adjudication_required_when" => [
          "reviewers disagree on task_critical",
          "reviewers disagree on supporting versus irrelevant or harmful",
          "any reviewer marks harmful",
          "any reviewer marks needs_review"
        ],
        "records" => [],
        "unresolved_needs_review_count" => @not_yet_run
      },
      "fixture_oracle_exposure" => %{
        "primary_labelers" => "withheld until labels are frozen",
        "adjudicator" =>
          "allowed only after primary labels are frozen and must be recorded per adjudication record"
      }
    }
  end

  defp packet_readme(config) do
    """
    # Post-Stage-1 Lane B #{config.run_timestamp} Blinded Label Packet

    ## Purpose

    This packet is the active blinded Lane B labeling batch prepared from the
    `#{config.run_timestamp}` Lane A rerun that is `accepted_by_closure` for the named
    threshold-governed Document Ops Lane A sample.

    It prepares artifact packets for:

    - `evidence_sufficiency_score`
    - `context_omission_error_rate`
    - `working_set_relevance_score`

    It does not contain human labels, secondary-review labels, adjudicated labels,
    or inter-annotator agreement results. Label collection status is
    `Not yet run`.

    ## Packet Contents

    | Artifact | Purpose |
    | --- | --- |
    | `packet_manifest.json` | Coordinator manifest, source run linkage, review mode, blinding boundary, supersession note, and artifact paths. |
    | `redacted_task_packets/` | Primary-labeler task packets with fixture oracle role and description fields removed from `input_artifacts`. |
    | `evidence_sufficiency_items.jsonl` | Eight blinded evidence sufficiency label items sampled from the accepted run artifact. |
    | `working_set_context_items.jsonl` | Twelve blinded working-set omission and relevance items: six long-context tasks by two blinded context arms. |
    | `adjudication_placeholders.json` | Empty adjudication record scaffold and trigger rules. |
    | `../../Post_Stage_1_Lane_B_#{config.run_timestamp}_Label_Report_Skeleton.md` | Report skeleton for recording labels after collection. |

    ## Source Run

    - Source Lane A run:
      `#{config.run_json_path}`
    - Source run report:
      `#{config.run_report_path}`
    - Source closure:
      `#{config.closure_path}`
    - Label policy version: `#{@label_policy_version}`
    - Gate policy for context expansion planning: `#{@context_gate_policy_version}`
    - Source run threshold status: `pass_acceptance_candidate`
    - Source run closure status: `#{config.closure_status}`

    The source run remains a Lane A measured run. This Lane B packet is an
    evaluation-labeling artifact only and does not change the measured Lane A
    metrics or create any new closure status.

    ## Supersession Boundary

    This packet supersedes the prepared `20260530_141649` Lane B packet as the
    active labeling packet because the older packet was extracted from a Lane A run
    that was not `accepted_by_closure` and still contained the pre-repair
    `docops_struct_selector_missing_001` committed artifact. No human labels,
    secondary review, adjudication, or agreement reporting had been collected for
    that older packet.

    The older packet may remain in the repository only as a historical packet for
    that non-accepted source run. It must not be used as the current Lane B label
    source for accepted post-Stage-1 routing unless a future report explicitly
    chooses to label that historical run and states why.

    ## Review Modes

    | Metric | Review mode | Label collection status |
    | --- | --- | --- |
    | `evidence_sufficiency_score` | `double_human_adjudicated` | `Not yet run` |
    | `context_omission_error_rate` | `double_human_adjudicated` | `Not yet run` |
    | `working_set_relevance_score` | `double_human_adjudicated` | `Not yet run` |

    Double human annotation is the default for this first active packet. A
    documented secondary review may be used only if a later report records the
    substitution and still satisfies `#{@label_policy_version}`.

    ## Blinding Boundary

    Primary labelers may see:

    - the item JSONL records in this packet
    - redacted task packets and fixture input artifacts referenced by item paths
    - redacted candidate-ref inventories without fixture oracle role fields
    - anonymized context arm names, `context_arm_A` and `context_arm_B`
    - evidence packet, action, verifier output, and journal fields copied into the
      evidence item records

    Primary labelers must not see before labels are frozen:

    - fixture oracle fields such as `required_refs`, `relevant_refs`,
      `irrelevant_refs`, `omission_trap_refs`, `expected_runtime_status`,
      `expected_label_source`, expected failure labels, and original
      `input_artifacts.role` or `input_artifacts.description` fields
    - aggregate Lane A metric results for the item under review
    - context arm identity mapping from `context_arm_A` or `context_arm_B` to
      baseline or treatment
    - task success flags from the source run
    - post-run repair notes when labeling the measured artifact

    Coordinator-only source artifacts, including the original fixture `task.json`
    files, may be used after primary labels are frozen for scoring, secondary
    review, or adjudication. Any exposure during adjudication must be recorded in
    `adjudication_placeholders.json` or its filled successor.

    ## Candidate Sample

    The evidence sufficiency batch uses one sampled treatment evidence unit from
    each major Lane A stratum:

    | Item | Task | Stratum |
    | --- | --- | --- |
    #{evidence_readme_rows(config)}

    The working-set batch covers all six `working_set_long_context` tasks from the
    accepted run, each under two blinded context arms.

    ## Label Output Fields

    Evidence sufficiency item labels must fill:

    - raw `0-4` label or `needs_review`
    - normalized score, after adjudication only
    - reviewer ID or anonymized reviewer ID
    - confidence
    - rationale
    - referenced artifact IDs

    Working-set item labels must fill:

    - omission severity
    - omitted task-critical ref IDs
    - task-critical candidate ref IDs
    - per-ref relevance labels
    - packet relevance quality
    - reviewer ID or anonymized reviewer ID
    - confidence
    - rationale

    All fields are currently `Not yet run`.

    ## Interpretation Boundary

    This packet may support a future Lane B label report after labels are collected
    and adjudicated. Until then it may only be described as a prepared blinded label
    packet from the accepted Lane A source run. It must not be described as
    human-labeled evidence, H1-H5 validation, full Context OS validation,
    production readiness, a runtime approval path, or new closure acceptance beyond
    the Lane A `#{config.run_timestamp}` closure.
    """
  end

  defp label_report_skeleton(config) do
    """
    # Post-Stage-1 Lane B #{config.run_timestamp} Label Report Skeleton

    ## Experiment

    - Source experiment ID: `#{@experiment_id}`
    - Source sample frame: `#{@sample_frame}`
    - Source Lane A run timestamp: `#{config.run_timestamp}`
    - Source Lane A closure status: `#{config.closure_status}`
    - Lane B packet ID: `#{config.packet_id}`
    - Label policy version: `#{@label_policy_version}`
    - Metric policy version: `#{@metric_policy_version}`
    - Context gate policy version: `#{@context_gate_policy_version}`
    - Label collection status: `Not yet run`
    - Report status: `Not yet run`
    - Claim level before labels: prepared blinded label packet only

    ## Source Artifacts

    | Artifact | Path |
    | --- | --- |
    | Source run JSON | `#{config.run_json_path}` |
    | Source run summary | `#{config.summary_path}` |
    | Source fixture inventory | `#{config.fixture_inventory_path}` |
    | Lane A run report | `#{config.run_report_path}` |
    | Lane A closure | `#{config.closure_path}` |
    | Label packet manifest | `#{path_join(config.out_path, "packet_manifest.json")}` |
    | Redacted task packets | `#{ensure_trailing_slash(path_join(config.out_path, "redacted_task_packets"))}` |
    | Evidence sufficiency items | `#{path_join(config.out_path, "evidence_sufficiency_items.jsonl")}` |
    | Working-set context items | `#{path_join(config.out_path, "working_set_context_items.jsonl")}` |
    | Adjudication placeholders | `#{path_join(config.out_path, "adjudication_placeholders.json")}` |

    ## Supersession Boundary

    This report skeleton supersedes
    `Post_Stage_1_Lane_B_20260530_141649_Label_Report_Skeleton.md` as the active
    Lane B reporting shell. The older skeleton remains a historical shell for the
    non-accepted `20260530_141649` source run and its prepared packet only.

    The older packet must not be used as the current Lane B source for accepted
    post-Stage-1 routing because its source run was not `accepted_by_closure` and
    its `docops_struct_selector_missing_001` item records the pre-repair committed
    artifact. No labels had been collected for that older packet before this
    rebuild.

    ## Labeling Contract

    | Metric | Item count | Review mode | Label source | Status |
    | --- | ---: | --- | --- | --- |
    | `evidence_sufficiency_score` | 8 | `double_human_adjudicated` | `human` | `Not yet run` |
    | `context_omission_error_rate` | 12 | `double_human_adjudicated` | `human` | `Not yet run` |
    | `working_set_relevance_score` | 12 | `double_human_adjudicated` | `human` | `Not yet run` |

    Reviewer identity policy: anonymized reviewer IDs are allowed, but each raw
    label must preserve a stable reviewer ID.

    Fixture oracle metadata exposed before label freeze: `no`.

    Blinding policy: primary labelers see only the packet item records, referenced
    redacted task packets, fixture input artifacts, redacted candidate-ref
    inventories, and blinded context arm names. Fixture oracle role fields, original
    `input_artifacts.role` and `input_artifacts.description` fields, arm identity
    mapping, expected labels, task success flags, aggregate item metrics, and
    post-run repair notes remain withheld until labels are frozen.

    ## Candidate Sample

    Evidence sufficiency candidates:

    | Item | Task | Stratum | Source item file |
    | --- | --- | --- | --- |
    #{evidence_report_rows(config)}

    Working-set candidates:

    | Task | Blinded arms | Source item file |
    | --- | --- | --- |
    #{working_set_report_rows()}

    ## Label Results

    Human labels have not been collected.

    | Metric | Raw labels | Adjudicated labels | Score | `needs_review` count | Status |
    | --- | --- | --- | --- | --- | --- |
    | `evidence_sufficiency_score` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` |
    | `context_omission_error_rate` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` |
    | `working_set_relevance_score` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` | `Not yet run` |

    ## Adjudication

    Adjudication status: `Not yet run`.

    Required adjudication triggers:

    - any reviewer marks `needs_review`
    - evidence sufficiency labels differ by two or more levels
    - evidence sufficiency labels split across the `0-2` versus `3-4`
      acceptability boundary
    - reviewers disagree on `task_critical`, `critical_omission`, `harmful`, or
      denominator fields for working-set metrics

    Adjudication records must include original labels, adjudicated label,
    adjudicator ID, rationale, artifact refs inspected, and whether fixture oracle
    metadata was exposed.

    ## Agreement

    Inter-annotator agreement: `Not yet run`.

    If this first active batch remains too small for stable agreement statistics,
    report raw agreement counts and state that agreement statistics are not
    meaningful at the sample size.

    ## Interpretation Boundaries

    Allowed before labels are collected:

    - The `#{config.run_timestamp}` Lane A closure run has a prepared blinded Lane B label
      packet.
    - The packet includes candidate artifact paths, review modes, blinding
      boundary, supersession boundary, and adjudication placeholders for the three
      named metrics.

    Disallowed before labels are collected:

    - human-labeled broader evaluation evidence
    - new `accepted_by_closure` status beyond the Lane A source closure
    - H1-H5 validation
    - full Context OS validation
    - production readiness
    - human-in-the-loop verifier or runtime approval claims
    - replacing the measured Lane A aggregate metrics with label results

    ## Findings

    `Not yet run`.

    ## Failures And Risks

    `Not yet run`.

    ## Next Steps

    1. Freeze the primary labeling packet and distribute only the blinded item
       files and referenced source artifacts to reviewers.
    2. Collect two independent labels per item or record an allowed secondary
       review substitution.
    3. Freeze primary labels before exposing fixture oracle fields or arm identity
       mappings.
    4. Complete adjudication records for all required disagreements.
    5. Fill this report with raw labels, adjudicated labels, agreement counts, and
       interpretation boundaries.
    """
  end

  defp evidence_readme_rows(config) do
    @evidence_sample
    |> Enum.with_index(1)
    |> Enum.map(fn {{task_id, stratum}, index} ->
      "| `#{packet_prefix(config)}-es-#{pad3(index)}` | `#{task_id}` | `#{stratum}` |"
    end)
    |> Enum.join("\n")
  end

  defp evidence_report_rows(config) do
    @evidence_sample
    |> Enum.with_index(1)
    |> Enum.map(fn {{task_id, stratum}, index} ->
      "| `#{packet_prefix(config)}-es-#{pad3(index)}` | `#{task_id}` | `#{stratum}` | `evidence_sufficiency_items.jsonl` |"
    end)
    |> Enum.join("\n")
  end

  defp working_set_report_rows do
    @working_set_task_ids
    |> Enum.map(fn task_id ->
      "| `#{task_id}` | `context_arm_A`, `context_arm_B` | `working_set_context_items.jsonl` |"
    end)
    |> Enum.join("\n")
  end

  defp compact_evidence_packet(packet) do
    packet
    |> Map.take(~w(
        evidence_id
        episode_id
        step_id
        action_ref
        pre_state_hash
        post_state_hash
        pre_state_summary
        post_state_summary
        observation
        provenance
        runtime_context
        violated_constraints
      ))
    |> update_in(["observation"], fn
      observation when is_map(observation) -> Map.drop(observation, ["content"])
      observation -> observation
    end)
  end

  defp compact_action_under_review(step) do
    Map.take(step, ~w(
      action_type
      action_payload
      side_effect_class
      status
      preconditions
      postconditions
      rollback_policy
      verifier_requirements
    ))
  end

  defp compact_verifier_output(output) do
    Map.take(output, ~w(
      verifier_output_id
      decision
      confidence
      risk_score
      validity_score
      verification_scope
      violated_constraints
      required_extra_evidence
    ))
  end

  defp compact_commit_record(journal) do
    Map.take(journal, ~w(
      episode_id
      commit_status
      rollback_status
      evidence_refs
      verifier_output_refs
      state_hashes
    ))
  end

  defp candidate_ref_inventory(working_set) do
    refs =
      [
        get_in(working_set, ["baseline", "context", "included_refs"]),
        get_in(working_set, ["baseline", "context", "dropped_refs"]),
        get_in(working_set, ["treatment", "context", "working_set", "provenance", "included_refs"]),
        get_in(working_set, ["treatment", "context", "selected_refs"]),
        get_in(working_set, ["treatment", "context", "omitted_refs"])
      ]
      |> Enum.flat_map(&List.wrap/1)

    refs
    |> Enum.reduce(%{}, fn ref, acc ->
      ref_id = ref["ref_id"]

      if present?(ref_id) do
        Map.update(acc, ref_id, ref, &merge_ref(&1, ref))
      else
        acc
      end
    end)
    |> Map.values()
    |> Enum.sort_by(& &1["ref_id"])
    |> Enum.map(&Map.take(&1, ~w(ref_id kind source path content_hash)))
  end

  defp merge_ref(left, right) do
    Map.merge(left, right, fn _key, old, new ->
      if present?(new), do: new, else: old
    end)
  end

  defp selected_ref_ids(%{"working_set" => %{"provenance" => %{"included_refs" => refs}}}),
    do: Enum.map(refs, & &1["ref_id"])

  defp selected_ref_ids(%{"selected_refs" => refs}) when is_list(refs),
    do: Enum.map(refs, & &1["ref_id"])

  defp selected_ref_ids(%{"included_refs" => refs}) when is_list(refs),
    do: Enum.map(refs, & &1["ref_id"])

  defp selected_ref_ids(_context), do: []

  defp omitted_visible_ref_ids(inventory, selected_ids) do
    selected = MapSet.new(selected_ids)

    inventory
    |> Enum.map(& &1["ref_id"])
    |> Enum.reject(&MapSet.member?(selected, &1))
  end

  defp context_artifact_id(%{"artifact_id" => artifact_id}), do: artifact_id

  defp context_artifact_id(%{"working_set" => %{"working_set_id" => working_set_id}}),
    do: working_set_id

  defp context_artifact_id(_context), do: nil

  defp token_budget(%{"working_set" => %{"token_budget" => token_budget}}), do: token_budget

  defp token_budget(context) do
    Map.take(context, ~w(
      max_context_chars
      selected_context_chars
      estimated_tokens
      estimation_method
      budget_adhered
    ))
  end

  defp evidence_label_fields do
    %{
      "raw_label_0_to_4_or_needs_review" => @not_yet_run,
      "normalized_score" => @not_yet_run,
      "reviewer_id" => @not_yet_run,
      "confidence" => @not_yet_run,
      "rationale" => @not_yet_run,
      "referenced_artifact_ids" => @not_yet_run
    }
  end

  defp working_set_label_fields do
    %{
      "omission_severity" => @not_yet_run,
      "omitted_task_critical_ref_ids" => @not_yet_run,
      "task_critical_candidate_ref_ids" => @not_yet_run,
      "per_ref_relevance_labels" => @not_yet_run,
      "packet_relevance_quality" => @not_yet_run,
      "reviewer_id" => @not_yet_run,
      "confidence" => @not_yet_run,
      "rationale" => @not_yet_run
    }
  end

  defp load_existing_packet(config, task_ids) do
    paths = %{
      readme: Path.join(config.out_abs, "README.md"),
      packet_manifest: Path.join(config.out_abs, "packet_manifest.json"),
      evidence_sufficiency_items: Path.join(config.out_abs, "evidence_sufficiency_items.jsonl"),
      working_set_context_items: Path.join(config.out_abs, "working_set_context_items.jsonl"),
      adjudication_placeholders: Path.join(config.out_abs, "adjudication_placeholders.json"),
      label_report_skeleton: config.label_report_abs
    }

    missing =
      paths
      |> Enum.reduce([], fn {_key, path}, errors ->
        if File.exists?(path),
          do: errors,
          else: ["missing packet artifact: #{display_path(path, config.cwd)}" | errors]
      end)

    missing_redacted =
      task_ids
      |> Enum.reduce([], fn task_id, errors ->
        path = Path.join([config.out_abs, "redacted_task_packets", "#{task_id}.json"])

        if File.exists?(path),
          do: errors,
          else: ["missing redacted task packet: #{display_path(path, config.cwd)}" | errors]
      end)

    if missing ++ missing_redacted != [] do
      {:error, Enum.reverse(missing ++ missing_redacted)}
    else
      with {:ok, readme} <- load_text(paths.readme),
           {:ok, manifest} <- load_json(paths.packet_manifest),
           {:ok, evidence} <- load_jsonl(paths.evidence_sufficiency_items),
           {:ok, working_set} <- load_jsonl(paths.working_set_context_items),
           {:ok, adjudication} <- load_json(paths.adjudication_placeholders),
           {:ok, report} <- load_text(paths.label_report_skeleton),
           {:ok, redacted} <- load_redacted_packets(config, task_ids) do
        {:ok,
         %{
           readme: readme,
           packet_manifest: manifest,
           evidence_sufficiency_items: evidence,
           working_set_context_items: working_set,
           adjudication_placeholders: adjudication,
           label_report_skeleton: report,
           redacted_task_packets: redacted
         }}
      end
    end
  end

  defp load_redacted_packets(config, task_ids) do
    task_ids
    |> Enum.reduce_while({:ok, %{}}, fn task_id, {:ok, packets} ->
      path = Path.join([config.out_abs, "redacted_task_packets", "#{task_id}.json"])

      case load_json(path) do
        {:ok, task_packet} -> {:cont, {:ok, Map.put(packets, task_id, task_packet)}}
        {:error, errors} -> {:halt, {:error, errors}}
      end
    end)
  end

  defp check_packet_shape(errors, actual) do
    prefix = packet_prefix_from_manifest(actual.packet_manifest)

    errors
    |> require_count("evidence sufficiency item count", actual.evidence_sufficiency_items, 8)
    |> require_count("working-set context item count", actual.working_set_context_items, 12)
    |> require_values(
      "evidence sufficiency item IDs",
      Enum.map(actual.evidence_sufficiency_items, & &1["packet_id"]),
      expected_evidence_ids(prefix)
    )
    |> require_values(
      "evidence sufficiency task IDs",
      Enum.map(actual.evidence_sufficiency_items, & &1["task_id"]),
      Enum.map(@evidence_sample, fn {task_id, _stratum} -> task_id end)
    )
    |> require_values(
      "working-set item IDs",
      Enum.map(actual.working_set_context_items, & &1["packet_id"]),
      expected_working_set_ids(prefix)
    )
    |> require_values(
      "working-set task IDs",
      actual.working_set_context_items
      |> Enum.map(& &1["task_id"])
      |> Enum.chunk_every(2)
      |> Enum.map(&List.first/1),
      @working_set_task_ids
    )
  end

  defp check_redaction(errors, actual) do
    redacted_errors =
      actual.redacted_task_packets
      |> Enum.flat_map(fn {task_id, task_packet} ->
        input_errors =
          Enum.flat_map(task_packet["input_artifacts"] || [], fn input_artifact ->
            ["role", "description"]
            |> Enum.filter(&Map.has_key?(input_artifact, &1))
            |> Enum.map(&"#{task_id} redacted input_artifacts still exposes #{&1}")
          end)

        task_errors =
          task_packet
          |> forbidden_keys(@redacted_task_oracle_fields)
          |> Enum.map(&"#{task_id} redacted task packet still exposes #{&1}")

        input_errors ++ task_errors
      end)

    context_errors =
      actual.working_set_context_items
      |> Enum.flat_map(fn item ->
        forbidden_keys(item, @forbidden_packet_keys)
        |> Enum.map(&"#{item["packet_id"]} working-set packet exposes forbidden key #{&1}")
      end)

    Enum.reduce(redacted_errors ++ context_errors, errors, &[&1 | &2])
  end

  defp check_not_yet_run_labels(errors, actual) do
    label_errors =
      [
        actual.packet_manifest["label_collection_status"],
        get_in(actual.packet_manifest, ["adjudication", "status"]),
        actual.adjudication_placeholders["status"]
      ]
      |> Enum.with_index()
      |> Enum.flat_map(fn {value, index} ->
        if value == @not_yet_run, do: [], else: ["label status #{index} is #{inspect(value)}"]
      end)

    item_errors =
      (actual.evidence_sufficiency_items ++ actual.working_set_context_items)
      |> Enum.flat_map(fn item ->
        fields = Map.values(item["primary_label_fields"] || %{})

        cond do
          item["label_status"] != @not_yet_run ->
            ["#{item["packet_id"]} label_status is #{inspect(item["label_status"])}"]

          item["adjudication_status"] != @not_yet_run ->
            [
              "#{item["packet_id"]} adjudication_status is #{inspect(item["adjudication_status"])}"
            ]

          Enum.any?(fields, &(&1 != @not_yet_run)) ->
            ["#{item["packet_id"]} has primary label fields not marked Not yet run"]

          true ->
            []
        end
      end)

    Enum.reduce(label_errors ++ item_errors, errors, &[&1 | &2])
  end

  defp check_selector_repair_item(errors, actual) do
    item =
      Enum.find(actual.evidence_sufficiency_items, fn item ->
        item["task_id"] == "docops_struct_selector_missing_001"
      end)

    checks = [
      {"action status", get_in(item, ["action_under_review", "status"]), "rejected"},
      {"verifier decision", get_in(item, ["verifier_output", "decision"]), "reject"},
      {
        "selector status",
        get_in(item, ["evidence_packet", "observation", "selector_resolution", "status"]),
        "missing"
      },
      {
        "selector type",
        get_in(item, ["action_under_review", "action_payload", "selector", "type"]),
        "section"
      },
      {
        "selector heading",
        get_in(item, ["action_under_review", "action_payload", "selector", "heading"]),
        "Missing"
      }
    ]

    Enum.reduce(checks, errors, fn {label, actual_value, expected_value}, acc ->
      if actual_value == expected_value do
        acc
      else
        [
          "docops_struct_selector_missing_001 #{label} is #{inspect(actual_value)}, expected #{inspect(expected_value)}"
          | acc
        ]
      end
    end)
  end

  defp require_equal(errors, label, actual, expected) do
    if actual == expected do
      errors
    else
      [
        "#{label} does not match regenerated source artifact#{diff_summary(actual, expected)}"
        | errors
      ]
    end
  end

  defp diff_summary(actual, expected) when is_list(actual) and is_list(expected) do
    cond do
      length(actual) != length(expected) ->
        " (actual count #{length(actual)}, expected #{length(expected)})"

      true ->
        index = Enum.find_index(Enum.zip(actual, expected), fn {left, right} -> left != right end)

        if is_integer(index) do
          {left, right} = Enum.at(Enum.zip(actual, expected), index)
          " (first mismatch at index #{index}: #{diff_summary(left, right)})"
        else
          ""
        end
    end
  end

  defp diff_summary(actual, expected) when is_map(actual) and is_map(expected) do
    actual_keys = actual |> Map.keys() |> MapSet.new()
    expected_keys = expected |> Map.keys() |> MapSet.new()
    only_actual = actual_keys |> MapSet.difference(expected_keys) |> MapSet.to_list()
    only_expected = expected_keys |> MapSet.difference(actual_keys) |> MapSet.to_list()

    common_mismatch =
      actual_keys
      |> MapSet.intersection(expected_keys)
      |> Enum.find(fn key -> actual[key] != expected[key] end)

    packet =
      case {actual["packet_id"], expected["packet_id"]} do
        {same, same} when is_binary(same) ->
          " packet_id=#{same},"

        {left, right} when is_binary(left) or is_binary(right) ->
          " packet_id #{inspect(left)} vs #{inspect(right)},"

        _other ->
          ""
      end

    nested =
      if is_nil(common_mismatch) do
        ""
      else
        ": #{diff_summary(actual[common_mismatch], expected[common_mismatch])}"
      end

    " (#{packet} only_actual=#{inspect(only_actual)}, only_expected=#{inspect(only_expected)}, first_value_mismatch=#{inspect(common_mismatch)}#{nested})"
  end

  defp diff_summary(actual, expected),
    do: " (actual=#{inspect(actual)}, expected=#{inspect(expected)})"

  defp check_required_text(errors, label, text, required_strings) do
    required_strings
    |> Enum.reject(&String.contains?(text, &1))
    |> Enum.reduce(errors, fn missing, acc ->
      ["#{label} does not contain #{inspect(missing)}" | acc]
    end)
  end

  defp require_count(errors, label, list, expected_count) do
    if length(list) == expected_count do
      errors
    else
      ["#{label} is #{length(list)}, expected #{expected_count}" | errors]
    end
  end

  defp require_values(errors, label, actual, expected) do
    if actual == expected do
      errors
    else
      ["#{label} is #{inspect(actual)}, expected #{inspect(expected)}" | errors]
    end
  end

  defp forbidden_keys(value, forbidden_keys), do: forbidden_keys(value, forbidden_keys, [])

  defp forbidden_keys(map, forbidden_keys, acc) when is_map(map) do
    map
    |> Enum.reduce(acc, fn {key, value}, acc ->
      acc =
        if key in forbidden_keys do
          [key | acc]
        else
          acc
        end

      forbidden_keys(value, forbidden_keys, acc)
    end)
  end

  defp forbidden_keys(list, forbidden_keys, acc) when is_list(list) do
    Enum.reduce(list, acc, &forbidden_keys(&1, forbidden_keys, &2))
  end

  defp forbidden_keys(_value, _forbidden_keys, acc), do: Enum.uniq(acc)

  defp expected_evidence_ids(prefix) do
    @evidence_sample
    |> Enum.with_index(1)
    |> Enum.map(fn {_sample, index} -> "#{prefix}-es-#{pad3(index)}" end)
  end

  defp expected_working_set_ids(prefix) do
    @working_set_task_ids
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {_task_id, index} ->
      [
        "#{prefix}-ws-#{pad3(index)}-context_arm_A",
        "#{prefix}-ws-#{pad3(index)}-context_arm_B"
      ]
    end)
  end

  defp packet_prefix_from_manifest(manifest) do
    case get_in(manifest, ["source_run", "run_timestamp"]) do
      timestamp when is_binary(timestamp) -> "lb#{packet_date(timestamp)}"
      _other -> "lb#{packet_date(@default_run_timestamp)}"
    end
  end

  defp find_task(run, task_id) do
    case Enum.find(run["tasks"] || [], &(&1["task_id"] == task_id)) do
      nil -> {:error, ["source run is missing task #{task_id}"]}
      task -> {:ok, task}
    end
  end

  defp ensure_stratum(%{"stratum" => stratum}, _task_id, stratum), do: :ok

  defp ensure_stratum(task, task_id, expected_stratum) do
    {:error,
     [
       "#{task_id} stratum is #{inspect(task["stratum"])}, expected #{inspect(expected_stratum)}"
     ]}
  end

  defp required_map(map, keys, label) do
    case get_in(map, keys) do
      value when is_map(value) -> {:ok, value}
      _other -> {:error, ["#{label} is missing #{Enum.join(keys, ".")}"]}
    end
  end

  defp first_item(list, _label) when is_list(list) and list != [], do: {:ok, hd(list)}
  defp first_item(_list, label), do: {:error, ["missing #{label}"]}

  defp packet_task_ids do
    @evidence_sample
    |> Enum.map(fn {task_id, _stratum} -> task_id end)
    |> Kernel.++(@working_set_task_ids)
    |> Enum.uniq()
  end

  defp redacted_task_packet_path(config, task_id) do
    path_join(config.out_path, "redacted_task_packets/#{task_id}.json")
  end

  defp source_artifact_dir(config, task_id) do
    config.fixtures_path
    |> path_join("#{task_id}/inputs")
    |> ensure_trailing_slash()
  end

  defp packet_id(run_timestamp) do
    [date, time] = String.split(run_timestamp, "_", parts: 2)
    "PS1-LB-PACKET-#{date}-#{time}-BATCH-001"
  end

  defp packet_prefix(%{packet_date: packet_date}), do: "lb#{packet_date}"
  defp packet_date(run_timestamp), do: run_timestamp |> String.split("_") |> hd()

  defp pad3(number) do
    number
    |> Integer.to_string()
    |> String.pad_leading(3, "0")
  end

  defp closure_status(path) do
    case File.read(path) do
      {:ok, content} ->
        case Regex.run(~r/Status:\s+`([^`]+)`/, content) do
          [_, status] -> status
          _other -> "unknown"
        end

      {:error, _reason} ->
        "unknown"
    end
  end

  defp load_text(path) do
    case File.read(path) do
      {:ok, text} -> {:ok, strip_bom(text)}
      {:error, reason} -> {:error, ["failed to read #{path}: #{:file.format_error(reason)}"]}
    end
  end

  defp load_json(path) do
    with {:ok, text} <- load_text(path),
         {:ok, json} <- Jason.decode(text) do
      {:ok, json}
    else
      {:error, errors} when is_list(errors) ->
        {:error, errors}

      {:error, %Jason.DecodeError{} = error} ->
        {:error, ["failed to decode JSON #{path}: #{Exception.message(error)}"]}
    end
  end

  defp load_jsonl(path) do
    with {:ok, text} <- load_text(path) do
      text
      |> String.split(~r/\R/, trim: true)
      |> Enum.reduce_while({:ok, []}, fn line, {:ok, rows} ->
        case Jason.decode(line) do
          {:ok, row} ->
            {:cont, {:ok, rows ++ [row]}}

          {:error, error} ->
            {:halt, {:error, ["failed to decode JSONL #{path}: #{Exception.message(error)}"]}}
        end
      end)
    end
  end

  defp write_json!(path, data), do: write_text!(path, Jason.encode!(data, pretty: true))

  defp write_jsonl!(path, rows) do
    text =
      rows
      |> Enum.map(&Jason.encode!/1)
      |> Enum.join("\n")

    write_text!(path, text <> "\n")
  end

  defp write_text!(path, text), do: File.write!(path, text)

  defp strip_bom(<<0xEF, 0xBB, 0xBF, rest::binary>>), do: rest
  defp strip_bom(text), do: text

  defp display_path(path, cwd) do
    expanded = Path.expand(path, cwd)
    cwd = Path.expand(cwd)
    relative = Path.relative_to(expanded, cwd)

    relative
    |> slash_path()
  end

  defp path_join(left, right), do: Path.join(left, right) |> slash_path()

  defp slash_path(path), do: String.replace(path, "\\", "/")

  defp ensure_trailing_slash(path) do
    if String.ends_with?(path, "/"), do: path, else: path <> "/"
  end

  defp present?(value) when is_binary(value), do: String.trim(value) != ""
  defp present?(nil), do: false
  defp present?(_value), do: true
end
