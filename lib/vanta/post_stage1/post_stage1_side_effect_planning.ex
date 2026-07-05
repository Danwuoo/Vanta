defmodule Vanta.PostStage1SideEffectPlanning do
  @moduledoc """
  Planning-only scaffold generator for the first PS1-G8 side-effect artifact contract.

  This module writes future-facing planning artifacts only. It does not call the
  runtime, compile Execution IR, collect approvals, or execute any COMMITTABLE,
  IRREVERSIBLE, or MEMORY_WRITE effect.
  """

  @experiment_id "side_effect_planning"
  @plan_id "PS1-LC-SIDEFX-PLAN-001"
  @surface_id "PS1-LC-SIDEFX-COMMITTABLE-DOCOPS-001"
  @gate_policy_version "PS1-LC-SIDEFX-GATE-001"
  @artifact_contract_version "PS1-G8-side-effect-planning-scaffold-v0"
  @placeholder_action "commit_fixture_document_candidate"

  @artifact_files ~w(
    run.json
    summary.md
    fixture_inventory.md
    commit_plan_inventory.md
    approval_boundary_report.md
    rollback_compensation_report.md
    schema_impact_ref.md
    not_applicable.md
  )

  @source_documents [
    "docs/02_specs/Post_Stage_1_Side_Effect_Planning_Draft_Spec.md",
    "docs/03_schemas/Post_Stage_1_Side_Effect_Schema_Impact_Review.md",
    "docs/04_experiments/Post_Stage_1_Side_Effect_Evaluation_Plan.md",
    "docs/00_manifest/Side_Effect_Escalation_Gate.md"
  ]

  @future_fixture_families [
    {"valid_fixture_local_commit_proposal",
     "future planning record with target identity, hashes, approval boundary, duplicate guard, verifier requirements, and rollback or compensation statement"},
    {"missing_target_identity", "planning review rejection candidate"},
    {"missing_approval_boundary", "blocked_missing_approval candidate"},
    {"missing_duplicate_guard", "planning review rejection candidate"},
    {"missing_rollback_or_compensation_statement",
     "blocked_missing_compensation_policy candidate"},
    {"path_escape_or_source_fixture_mutation", "blocked_path_escape candidate"},
    {"irreversible_misclassification", "blocked_irreversible_misclassification candidate"},
    {"memory_write_smuggling", "blocked_memory_write candidate"}
  ]

  def artifact_files, do: @artifact_files

  def plan_id, do: @plan_id

  def surface_id, do: @surface_id

  def gate_policy_version, do: @gate_policy_version

  def placeholder_action, do: @placeholder_action

  def generate(opts \\ []) do
    opts = normalize_opts(opts)
    run = build_run(opts)

    write_results!(opts.out_dir, run)

    {:ok, run}
  end

  def build_run(opts \\ []) do
    opts =
      if is_map(opts) do
        opts
      else
        normalize_opts(opts)
      end

    artifact_root = display_path(opts.out_dir, opts.cwd)

    %{
      "schema_version" => Vanta.schema_version(),
      "experiment_id" => @experiment_id,
      "plan_id" => @plan_id,
      "planning_surface_id" => @surface_id,
      "gate_policy_version" => @gate_policy_version,
      "artifact_contract_version" => @artifact_contract_version,
      "generation_mode" => "planning-only scaffold",
      "report_label" => "side_effect_planning_draft",
      "run_status" => "Not yet run",
      "implementation_status" => "Not authorized",
      "runtime_execution_status" => "Not authorized",
      "approval_collection_status" => "Not authorized",
      "schema_change_status" => "no schema changes",
      "generated_at" => opts.generated_at,
      "artifact_root" => artifact_root,
      "artifact_contract" => artifact_contract(),
      "artifact_refs" => artifact_refs(),
      "source_documents" => @source_documents,
      "planning_boundary" => planning_boundary(),
      "future_action_placeholder" => future_action_placeholder(),
      "planning_stub_inventory" => planning_stub_inventory(),
      "future_fixture_families" => future_fixture_families(),
      "executed_side_effect_counts" => executed_side_effect_counts(),
      "process_integrity_floors" => process_integrity_floors(),
      "claim_boundary" => claim_boundary()
    }
  end

  defp normalize_opts(opts) do
    cwd = Keyword.get_lazy(opts, :cwd, &File.cwd!/0)
    timestamp = Keyword.get_lazy(opts, :timestamp, &timestamp/0)

    out_dir =
      opts
      |> Keyword.get(:out_dir, "docs/04_experiments/results/side_effect_planning/#{timestamp}")
      |> Path.expand(cwd)

    generated_at =
      Keyword.get_lazy(opts, :generated_at, fn ->
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> DateTime.to_iso8601()
      end)

    %{cwd: cwd, out_dir: out_dir, timestamp: timestamp, generated_at: generated_at}
  end

  defp artifact_contract do
    %{
      "required_files" => @artifact_files,
      "output_root_pattern" => "docs/04_experiments/results/side_effect_planning/<timestamp>/",
      "contract_status" => "planning-only scaffold",
      "label_packet_ref" => "not_applicable.md",
      "machine_schema" => "not added in this batch"
    }
  end

  defp artifact_refs do
    %{
      "run" => "run.json",
      "summary" => "summary.md",
      "fixture_inventory" => "fixture_inventory.md",
      "commit_plan_inventory" => "commit_plan_inventory.md",
      "approval_boundary_report" => "approval_boundary_report.md",
      "rollback_compensation_report" => "rollback_compensation_report.md",
      "schema_impact_ref" => "schema_impact_ref.md",
      "label_packet_or_stub" => "not_applicable.md"
    }
  end

  defp planning_boundary do
    %{
      "boundary" => "planning-only",
      "authorized_runtime_actions_added" => [],
      "runtime_dispatch" => "Not authorized",
      "approval_records_collected" => 0,
      "labels_are_runtime_approvals" => false,
      "fixture_oracles_are_runtime_approvals" => false,
      "target_scope" => "future copied fixture workspace artifacts only",
      "source_fixture_mutation_allowed" => false,
      "external_targets_allowed" => false,
      "production_targets_allowed" => false,
      "memory_stores_allowed" => false
    }
  end

  defp future_action_placeholder do
    %{
      "name" => @placeholder_action,
      "status" => "planning placeholder only",
      "side_effect_class" => "COMMITTABLE",
      "present_in_current_action_set" => @placeholder_action in Vanta.action_types(),
      "present_in_allowed_actions" => false,
      "runtime_dispatch_allowed" => false
    }
  end

  defp planning_stub_inventory do
    [
      %{
        "stub_id" => "sidefx_docops_commit_proposal_stub_001",
        "surface_id" => @surface_id,
        "gate_policy_version" => @gate_policy_version,
        "side_effect_class" => "COMMITTABLE",
        "status" => "Not authorized",
        "execution_status" => "not_executed",
        "proposal_record_status" => "stub_only",
        "approval_record_status" => "not_collected",
        "rollback_or_compensation_status" => "future_requirement_only",
        "target_scope" => "future copied fixture workspace only",
        "runtime_action_added" => false
      }
    ]
  end

  defp future_fixture_families do
    Enum.map(@future_fixture_families, fn {family, expected_result} ->
      %{
        "family" => family,
        "expected_planning_result" => expected_result,
        "runnable_fixture_status" => "not_added"
      }
    end)
  end

  defp executed_side_effect_counts do
    %{
      "COMMITTABLE" => 0,
      "IRREVERSIBLE" => 0,
      "MEMORY_WRITE" => 0
    }
  end

  defp process_integrity_floors do
    %{
      "runtime_committable_execution_count" => 0,
      "runtime_irreversible_execution_count" => 0,
      "memory_write_count" => 0,
      "external_target_count" => 0,
      "production_target_count" => 0,
      "source_fixture_mutation_count" => 0,
      "unsupported_commit_count" => 0,
      "approval_as_label_count" => 0,
      "approval_record_count" => 0,
      "schema_change_count" => 0,
      "runtime_action_added_count" => 0
    }
  end

  defp claim_boundary do
    %{
      "claim_level" => "planning artifact only",
      "h5_validation" => "not claimed",
      "side_effect_safety" => "not claimed",
      "runtime_approval" => "not collected",
      "runtime_execution_authorization" => "Not authorized",
      "production_deployment" => "not approved"
    }
  end

  defp write_results!(out_dir, run) do
    File.mkdir_p!(out_dir)

    File.write!(Path.join(out_dir, "run.json"), Jason.encode!(run, pretty: true))
    File.write!(Path.join(out_dir, "summary.md"), summary_markdown(run))
    File.write!(Path.join(out_dir, "fixture_inventory.md"), fixture_inventory_markdown(run))

    File.write!(
      Path.join(out_dir, "commit_plan_inventory.md"),
      commit_plan_inventory_markdown(run)
    )

    File.write!(
      Path.join(out_dir, "approval_boundary_report.md"),
      approval_boundary_markdown(run)
    )

    File.write!(
      Path.join(out_dir, "rollback_compensation_report.md"),
      rollback_compensation_markdown(run)
    )

    File.write!(Path.join(out_dir, "schema_impact_ref.md"), schema_impact_markdown(run))
    File.write!(Path.join(out_dir, "not_applicable.md"), not_applicable_markdown(run))
  end

  defp summary_markdown(run) do
    counts = run["executed_side_effect_counts"]
    floors = run["process_integrity_floors"]

    """
    # Post-Stage-1 Side-Effect Planning Scaffold

    Plan ID: #{run["plan_id"]}
    Planning surface ID: #{run["planning_surface_id"]}
    Gate policy version: #{run["gate_policy_version"]}
    Report label: #{run["report_label"]}
    Generation mode: #{run["generation_mode"]}
    Run status: #{run["run_status"]}
    Implementation status: #{run["implementation_status"]}
    Runtime execution status: #{run["runtime_execution_status"]}
    Approval collection status: #{run["approval_collection_status"]}
    Schema change status: #{run["schema_change_status"]}

    ## Artifact Contract

    | File | Status |
    | --- | --- |
    #{artifact_rows(run)}

    ## Executed High-Risk Effects

    | Effect | Count |
    | --- | ---: |
    | `COMMITTABLE` | #{counts["COMMITTABLE"]} |
    | `IRREVERSIBLE` | #{counts["IRREVERSIBLE"]} |
    | `MEMORY_WRITE` | #{counts["MEMORY_WRITE"]} |

    ## Process Floors

    - runtime_committable_execution_count: #{floors["runtime_committable_execution_count"]}
    - runtime_irreversible_execution_count: #{floors["runtime_irreversible_execution_count"]}
    - memory_write_count: #{floors["memory_write_count"]}
    - external_target_count: #{floors["external_target_count"]}
    - production_target_count: #{floors["production_target_count"]}
    - source_fixture_mutation_count: #{floors["source_fixture_mutation_count"]}
    - approval_as_label_count: #{floors["approval_as_label_count"]}
    - schema_change_count: #{floors["schema_change_count"]}
    - runtime_action_added_count: #{floors["runtime_action_added_count"]}

    ## Interpretation Boundary

    This scaffold only materializes the PS1-G8 planning artifact contract. It is
    not an experiment result, does not add a runtime action, does not collect an
    approval record, does not execute a side effect, does not change schemas,
    does not validate H5, and does not approve deployment.
    """
  end

  defp fixture_inventory_markdown(run) do
    rows =
      run["future_fixture_families"]
      |> Enum.map(fn item ->
        "| `#{item["family"]}` | #{item["expected_planning_result"]} | #{item["runnable_fixture_status"]} |"
      end)
      |> Enum.join("\n")

    """
    # Fixture Inventory

    Planning surface ID: #{run["planning_surface_id"]}
    Runnable fixture count: 0
    Source fixture mutation count: #{get_in(run, ["process_integrity_floors", "source_fixture_mutation_count"])}

    This scaffold lists future fixture families only. It adds no runnable
    `COMMITTABLE`, `IRREVERSIBLE`, or `MEMORY_WRITE` fixture and mutates no
    source fixture, repository document, user file, external target, production
    target, or memory store.

    | Future family | Expected planning result | Runnable fixture status |
    | --- | --- | --- |
    #{rows}
    """
  end

  defp commit_plan_inventory_markdown(run) do
    rows =
      run["planning_stub_inventory"]
      |> Enum.map(fn item ->
        "| `#{item["stub_id"]}` | #{item["side_effect_class"]} | #{item["status"]} | #{item["execution_status"]} | #{item["runtime_action_added"]} |"
      end)
      |> Enum.join("\n")

    """
    # Commit Plan Inventory

    Planning surface ID: #{run["planning_surface_id"]}
    Future action placeholder: `#{@placeholder_action}`
    Placeholder status: planning placeholder only
    Executable commit plan count: 0
    Runtime action added count: #{get_in(run, ["process_integrity_floors", "runtime_action_added_count"])}

    The placeholder action is not part of the current action set, must not appear
    in runtime `allowed_actions`, and is not sent to `Vanta.Runtime.run_task/3`
    by this scaffold.

    | Stub ID | Side-effect class | Status | Execution status | Runtime action added |
    | --- | --- | --- | --- | --- |
    #{rows}
    """
  end

  defp approval_boundary_markdown(run) do
    floors = run["process_integrity_floors"]

    """
    # Approval Boundary Report

    Gate policy version: #{run["gate_policy_version"]}
    Approval collection status: #{run["approval_collection_status"]}
    Approval record count: #{floors["approval_record_count"]}
    Approval-as-label count: #{floors["approval_as_label_count"]}

    Future `COMMITTABLE` execution would require a distinct approval policy and
    approval record. This scaffold collects none. Human labels, fixture oracles,
    verifier output, and final-answer judgments are not runtime approvals.
    """
  end

  defp rollback_compensation_markdown(run) do
    floors = run["process_integrity_floors"]

    """
    # Rollback And Compensation Report

    Planning surface ID: #{run["planning_surface_id"]}
    Runtime execution status: #{run["runtime_execution_status"]}
    Runtime `COMMITTABLE` execution count: #{floors["runtime_committable_execution_count"]}
    Runtime `IRREVERSIBLE` execution count: #{floors["runtime_irreversible_execution_count"]}
    Memory-write count: #{floors["memory_write_count"]}

    Strict rollback is not assumed. A later executable batch must choose and
    justify `fixture_commit_restore` or `fixture_commit_supersede` before any
    runtime execution candidate can be reviewed. Compensation is not strict
    rollback.
    """
  end

  defp schema_impact_markdown(run) do
    floors = run["process_integrity_floors"]

    """
    # Schema Impact Reference

    Schema impact review:
    `docs/03_schemas/Post_Stage_1_Side_Effect_Schema_Impact_Review.md`

    Schema change status: #{run["schema_change_status"]}
    Schema change count: #{floors["schema_change_count"]}
    Runtime action added count: #{floors["runtime_action_added_count"]}

    This scaffold does not add `#{@placeholder_action}` to any runtime schema or
    allowlist. Existing `COMMITTABLE` enum references remain planning context
    only for this batch.
    """
  end

  defp not_applicable_markdown(run) do
    """
    # Not Applicable

    Label packet reference: not applicable
    Plan ID: #{run["plan_id"]}
    Planning surface ID: #{run["planning_surface_id"]}

    No label packet is produced by this scaffold. No human label, fixture oracle,
    verifier output, or review note is converted into runtime approval.
    """
  end

  defp artifact_rows(run) do
    run
    |> get_in(["artifact_contract", "required_files"])
    |> Enum.map(&"| `#{&1}` | generated |")
    |> Enum.join("\n")
  end

  defp display_path(path, cwd) do
    path
    |> Path.relative_to(cwd)
    |> String.replace("\\", "/")
  end

  defp timestamp do
    {{year, month, day}, {hour, minute, second}} = :calendar.local_time()

    :io_lib.format(
      "~4..0B~2..0B~2..0B_~2..0B~2..0B~2..0B",
      [year, month, day, hour, minute, second]
    )
    |> IO.iodata_to_binary()
  end
end
