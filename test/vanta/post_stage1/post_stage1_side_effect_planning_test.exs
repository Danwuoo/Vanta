defmodule Vanta.PostStage1SideEffectPlanningTest do
  use ExUnit.Case

  alias Vanta.PostStage1SideEffectPlanning

  @required_files ~w(
    run.json
    summary.md
    fixture_inventory.md
    commit_plan_inventory.md
    approval_boundary_report.md
    rollback_compensation_report.md
    schema_impact_ref.md
    not_applicable.md
  )

  @placeholder_action "commit_fixture_document_candidate"

  @tag :generated_artifact_tooling
  test "generator writes the PS1-G8 planning-only artifact contract" do
    out_dir = tmp_dir("sidefx_contract")

    assert {:ok, run} =
             PostStage1SideEffectPlanning.generate(
               out_dir: out_dir,
               generated_at: "2026-07-01T00:00:00Z"
             )

    assert run["plan_id"] == "PS1-LC-SIDEFX-PLAN-001"
    assert run["planning_surface_id"] == "PS1-LC-SIDEFX-COMMITTABLE-DOCOPS-001"
    assert run["gate_policy_version"] == "PS1-LC-SIDEFX-GATE-001"
    assert run["generation_mode"] == "planning-only scaffold"
    assert run["run_status"] == "Not yet run"
    assert run["implementation_status"] == "Not authorized"
    assert run["runtime_execution_status"] == "Not authorized"
    assert run["approval_collection_status"] == "Not authorized"
    assert get_in(run, ["artifact_contract", "required_files"]) == @required_files

    Enum.each(@required_files, fn file_name ->
      assert File.exists?(Path.join(out_dir, file_name)), "#{file_name} was not generated"
    end)

    assert Jason.decode!(File.read!(Path.join(out_dir, "run.json"))) == run

    summary = File.read!(Path.join(out_dir, "summary.md"))
    assert summary =~ "Generation mode: planning-only scaffold"
    assert summary =~ "Runtime execution status: Not authorized"
  end

  @tag :generated_artifact_tooling
  test "run.json locks high-risk executed effect counts to zero" do
    out_dir = tmp_dir("sidefx_counts")

    assert {:ok, run} =
             PostStage1SideEffectPlanning.generate(
               out_dir: out_dir,
               generated_at: "2026-07-01T00:00:00Z"
             )

    assert run["executed_side_effect_counts"] == %{
             "COMMITTABLE" => 0,
             "IRREVERSIBLE" => 0,
             "MEMORY_WRITE" => 0
           }

    floors = run["process_integrity_floors"]

    assert floors["runtime_committable_execution_count"] == 0
    assert floors["runtime_irreversible_execution_count"] == 0
    assert floors["memory_write_count"] == 0
    assert floors["external_target_count"] == 0
    assert floors["production_target_count"] == 0
    assert floors["source_fixture_mutation_count"] == 0
    assert floors["approval_record_count"] == 0
    assert floors["schema_change_count"] == 0
    assert floors["runtime_action_added_count"] == 0
  end

  @tag :generated_artifact_tooling
  test "generated artifacts keep disallowed claim boundary out of report text" do
    out_dir = tmp_dir("sidefx_claims")

    assert {:ok, _run} =
             PostStage1SideEffectPlanning.generate(
               out_dir: out_dir,
               generated_at: "2026-07-01T00:00:00Z"
             )

    generated_text =
      @required_files
      |> Enum.map(fn file_name -> File.read!(Path.join(out_dir, file_name)) end)
      |> Enum.join("\n")

    assert generated_text =~ "planning-only"
    assert generated_text =~ "Not authorized"
    assert generated_text =~ "does not add a runtime action"
    assert generated_text =~ "does not collect an\napproval record"

    Enum.each(
      [
        "accepted_by_closure",
        "H5 validated",
        "side-effect safety validated",
        "runtime approval collected",
        "COMMITTABLE execution authorized",
        "IRREVERSIBLE execution authorized",
        "MEMORY_WRITE authorized",
        "production ready"
      ],
      fn disallowed_claim ->
        refute generated_text =~ disallowed_claim
      end
    )
  end

  @tag :fast_unit
  test "planning placeholder remains outside runtime schemas and dispatch path" do
    assert @placeholder_action not in Vanta.action_types()

    assert %{
             "name" => @placeholder_action,
             "present_in_current_action_set" => false,
             "present_in_allowed_actions" => false,
             "runtime_dispatch_allowed" => false
           } = PostStage1SideEffectPlanning.build_run()["future_action_placeholder"]

    Enum.each(
      [
        "docs/03_schemas/execution_step.schema.json",
        "docs/03_schemas/planner_action_sequence.schema.json",
        "docs/03_schemas/benchmark_task.schema.json"
      ],
      fn schema_path ->
        refute File.read!(schema_path) =~ @placeholder_action,
               "#{schema_path} unexpectedly exposes #{@placeholder_action}"
      end
    )

    source = File.read!("lib/vanta/post_stage1/post_stage1_side_effect_planning.ex")
    refute source =~ "Runtime.run_task("
    refute source =~ "ExecutionIRCompiler"
    refute source =~ "ActionExecutor"
    refute source =~ "CommitController"
  end

  @tag :generated_artifact_tooling
  test "mix task can rerun the scaffold generator" do
    aliases = Mix.Project.config()[:aliases]

    assert aliases[:"vanta.post_stage_1_side_effect_planning"] == [
             "vanta.post_stage1_side_effect_planning"
           ]

    out_dir = tmp_dir("sidefx_mix_task")

    Mix.Task.reenable("vanta.post_stage1_side_effect_planning")
    Mix.Task.run("vanta.post_stage1_side_effect_planning", ["--out", out_dir])

    assert File.exists?(Path.join(out_dir, "run.json"))
    assert File.exists?(Path.join(out_dir, "summary.md"))

    run = Jason.decode!(File.read!(Path.join(out_dir, "run.json")))
    assert run["runtime_execution_status"] == "Not authorized"
    assert get_in(run, ["executed_side_effect_counts", "COMMITTABLE"]) == 0
  end

  defp tmp_dir(label) do
    out_dir =
      Path.join(System.tmp_dir!(), "vanta_#{label}_#{System.unique_integer([:positive])}")

    File.rm_rf!(out_dir)
    out_dir
  end
end
