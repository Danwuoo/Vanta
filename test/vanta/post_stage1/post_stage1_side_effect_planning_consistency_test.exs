defmodule Vanta.PostStage1SideEffectPlanningConsistencyTest do
  use ExUnit.Case, async: true

  @docs_root Path.expand("../../../docs", __DIR__)
  @chatgpt_docs_root Path.expand("../../../chatgpt_docs/docs", __DIR__)
  @chatgpt_docs_export_cap 25

  @planning_bundle_file_names [
    "Post_Stage_1_Side_Effect_Planning_Draft_Spec.md",
    "Post_Stage_1_Side_Effect_Schema_Impact_Review.md",
    "Post_Stage_1_Side_Effect_Evaluation_Plan.md"
  ]

  @routing_docs [
    "00_manifest/Project_Manifest.md",
    "00_manifest/Post_Stage_1_Advancement_Gate.md",
    "00_manifest/Post_Stage_1_Gate_Inventory.md",
    "00_manifest/Document_Map.md",
    "00_manifest/Traceability_Matrix.md"
  ]

  @ps1_g8_mirrored_docs [
    "00_manifest/Project_Manifest.md",
    "00_manifest/Post_Stage_1_Advancement_Gate.md",
    "00_manifest/Post_Stage_1_Gate_Inventory.md",
    "00_manifest/Document_Map.md",
    "00_manifest/Traceability_Matrix.md",
    "00_manifest/Side_Effect_Escalation_Gate.md",
    "02_specs/Execution_IR_and_Episode_Semantics.md",
    "02_specs/Evidence_Packet_and_Verifier_Runtime.md",
    "02_specs/Commit_Abort_Replay_Semantics.md",
    "02_specs/Post_Stage_1_Side_Effect_Planning_Draft_Spec.md",
    "03_schemas/Post_Stage_1_Side_Effect_Schema_Impact_Review.md",
    "04_experiments/Post_Stage_1_Side_Effect_Evaluation_Plan.md"
  ]

  @future_artifact_path "docs/04_experiments/results/side_effect_planning/<timestamp>/"
  @gate_policy "PS1-LC-SIDEFX-GATE-001"
  @surface_id "PS1-LC-SIDEFX-COMMITTABLE-DOCOPS-001"
  @placeholder_action "commit_fixture_document_candidate"

  @tag :docs_consistency
  test "PS1-G8 planning bundle stays routed through manifest, map, traceability, and gate inventory" do
    Enum.each(@routing_docs, fn relative_path ->
      text = read_doc(relative_path)

      assert_contains(text, "`PS1-G8`", relative_path)
      assert_contains(text, "Side-Effect Escalation Gate", relative_path)

      Enum.each(@planning_bundle_file_names, fn file_name ->
        assert_contains(text, file_name, relative_path)
      end)
    end)

    assert_contains(
      read_doc("00_manifest/Project_Manifest.md"),
      "The first `PS1-G8` side-effect planning bundle is now routed through",
      "Project Manifest"
    )

    assert_contains(
      read_doc("00_manifest/Post_Stage_1_Advancement_Gate.md"),
      "The first `PS1-G8` planning bundle is now routed through",
      "Post-Stage-1 Advancement Gate"
    )

    assert_contains(
      read_doc("00_manifest/Post_Stage_1_Gate_Inventory.md"),
      "The first `PS1-G8` side-effect planning bundle is routed through",
      "Post-Stage-1 Gate Inventory"
    )

    assert_contains(
      read_doc("00_manifest/Document_Map.md"),
      "are the first `PS1-G8` planning bundle. They define a fixture-local Document Ops `COMMITTABLE` commit-proposal planning surface only.",
      "Document Map"
    )

    assert_contains(
      read_doc("00_manifest/Traceability_Matrix.md"),
      "| Side-effect planning bundle |",
      "Traceability Matrix"
    )
  end

  @tag :docs_consistency
  test "PS1-LC-SIDEFX-GATE-001 wording and Not authorized boundary stay aligned" do
    gate = read_doc("00_manifest/Side_Effect_Escalation_Gate.md")
    spec = read_doc("02_specs/Post_Stage_1_Side_Effect_Planning_Draft_Spec.md")
    schema_review = read_doc("03_schemas/Post_Stage_1_Side_Effect_Schema_Impact_Review.md")
    evaluation_plan = read_doc("04_experiments/Post_Stage_1_Side_Effect_Evaluation_Plan.md")

    assert_contains(gate, "Gate policy ID: `#{@gate_policy}`", "Side-Effect Escalation Gate")

    Enum.each(
      [
        {"Side-effect planning draft spec", spec},
        {"Side-effect schema impact review", schema_review},
        {"Side-effect evaluation plan", evaluation_plan}
      ],
      fn {label, text} ->
        assert_contains(text, "Gate policy version: `#{@gate_policy}`.", label)
        assert_contains(text, "Planning surface ID: `#{@surface_id}`.", label)
      end
    )

    assert_contains(
      gate,
      "Accepted unlock: side-effect specification, schema impact review, evaluation planning, and implementation planning only.",
      "Side-Effect Escalation Gate"
    )

    assert_contains(
      gate,
      "This bundle defines a fixture-local Document Ops `COMMITTABLE` planning surface only. It does not authorize runtime execution, schema changes, approval collection, experiments, production readiness, or H5 validation.",
      "Side-Effect Escalation Gate"
    )

    assert_contains(spec, "Implementation status: `Not authorized`.", "Side-effect spec")
    assert_contains(spec, "Runtime execution status: `Not authorized`.", "Side-effect spec")

    assert_contains(
      spec,
      "Allowed side-effect scope in this draft: `COMMITTABLE` planning placeholder for fixture-local Document Ops only.",
      "Side-effect spec"
    )

    assert_contains(
      spec,
      "Claim level: planning artifact only. This document does not validate H5, approve production readiness, or create a runtime approval path.",
      "Side-effect spec"
    )

    assert_contains(
      schema_review,
      "Schema decision for this batch: no schema changes.",
      "Side-effect schema impact review"
    )

    assert_contains(
      schema_review,
      "Implementation status: `Not authorized`.",
      "Side-effect schema impact review"
    )

    assert_contains(
      schema_review,
      "Runtime execution status: `Not authorized`.",
      "Side-effect schema impact review"
    )

    assert_contains(
      evaluation_plan,
      "Implementation status: `Not authorized`.",
      "Side-effect evaluation plan"
    )

    assert_contains(
      evaluation_plan,
      "Runtime execution status: `Not authorized`.",
      "Side-effect evaluation plan"
    )
  end

  @tag :fast_unit
  test "COMMITTABLE planning placeholder remains outside runtime schemas and module wiring" do
    runtime_plan = read_doc("06_engineering/Runtime_Module_Plan.md")
    spec = read_doc("02_specs/Post_Stage_1_Side_Effect_Planning_Draft_Spec.md")
    schema_review = read_doc("03_schemas/Post_Stage_1_Side_Effect_Schema_Impact_Review.md")

    assert_contains(
      runtime_plan,
      "The first `PS1-G8` side-effect planning bundle defines only a fixture-local Document Ops `COMMITTABLE` commit-proposal planning surface.",
      "Runtime Module Plan"
    )

    assert_contains(
      runtime_plan,
      "It must not be wired into the Planner Adapter, Execution IR Compiler, Action Executor, Verifier Runtime, Commit Controller, or Episode Journal as executable runtime behavior without a later accepted schema, implementation, fixture, test, and evaluation batch.",
      "Runtime Module Plan"
    )

    assert_contains(
      spec,
      "The future action name `#{@placeholder_action}` is a planning placeholder only. It is not present in current action schemas, must not appear in `allowed_actions`, and must not be sent to `Vanta.Runtime.run_task/3` under this batch.",
      "Side-effect spec"
    )

    assert_contains(
      schema_review,
      "Do not add `#{@placeholder_action}` or any other `COMMITTABLE` action name.",
      "Side-effect schema impact review"
    )

    Enum.each(
      [
        "03_schemas/execution_step.schema.json",
        "03_schemas/planner_action_sequence.schema.json",
        "03_schemas/benchmark_task.schema.json"
      ],
      fn relative_path ->
        refute read_doc(relative_path) =~ @placeholder_action,
               "#{relative_path} unexpectedly exposes #{@placeholder_action}"
      end
    )
  end

  @tag :docs_consistency
  test "future side-effect planning artifact contract remains non-executing and future-only" do
    evaluation_plan = read_doc("04_experiments/Post_Stage_1_Side_Effect_Evaluation_Plan.md")
    traceability = read_doc("00_manifest/Traceability_Matrix.md")

    assert_contains(evaluation_plan, @future_artifact_path, "Side-effect evaluation plan")
    assert_contains(traceability, @future_artifact_path, "Traceability Matrix")

    Enum.each(
      [
        "run.json",
        "summary.md",
        "fixture_inventory.md",
        "commit_plan_inventory.md",
        "approval_boundary_report.md",
        "rollback_compensation_report.md",
        "schema_impact_ref.md",
        "label_packet_ref.md` or `not_applicable.md"
      ],
      fn required_file ->
        assert_contains(evaluation_plan, required_file, "Side-effect evaluation plan")
      end
    )

    assert_contains(
      evaluation_plan,
      "No artifact path in this section authorizes runtime execution.",
      "Side-effect evaluation plan"
    )

    assert_contains(
      evaluation_plan,
      "`run.json` for a planning pilot must report execution counts for `COMMITTABLE`, `IRREVERSIBLE`, and `MEMORY_WRITE` as `0`.",
      "Side-effect evaluation plan"
    )

    Enum.each(
      [
        "| Executed `COMMITTABLE` actions | Must remain `0` in this planning plan. |",
        "| Executed `IRREVERSIBLE` actions | Must remain `0`. |",
        "| `MEMORY_WRITE` effects | Must remain `0`. |",
        "| `runtime_committable_execution_count` | `0` |",
        "| `runtime_irreversible_execution_count` | `0` |",
        "| `memory_write_count` | `0` |"
      ],
      fn floor ->
        assert_contains(evaluation_plan, floor, "Side-effect evaluation plan")
      end
    )
  end

  @tag :docs_consistency
  test "PS1-G8 mirror export stays capped and byte-for-byte synchronized" do
    mirrored_docs = mirrored_doc_paths()

    assert length(mirrored_docs) <= @chatgpt_docs_export_cap

    Enum.each(@ps1_g8_mirrored_docs, fn relative_path ->
      assert relative_path in mirrored_docs, "#{relative_path} is expected in chatgpt_docs mirror"
    end)

    Enum.each(mirrored_docs, fn relative_path ->
      source_path = Path.join(@docs_root, relative_path)
      mirror_path = Path.join(@chatgpt_docs_root, relative_path)

      assert File.exists?(source_path), "#{relative_path} has no source doc"
      assert File.read!(source_path) == File.read!(mirror_path)
    end)
  end

  defp read_doc(relative_path), do: File.read!(Path.join(@docs_root, relative_path))

  defp assert_contains(text, expected, label) do
    assert normalize(text) =~ normalize(expected),
           "#{label} missing expected text: #{expected}"
  end

  defp normalize(text), do: text |> String.replace(~r/\s+/, " ") |> String.trim()

  defp mirrored_doc_paths do
    @chatgpt_docs_root
    |> Path.join("**/*")
    |> Path.wildcard()
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&Path.relative_to(&1, @chatgpt_docs_root))
    |> Enum.map(&String.replace(&1, "\\", "/"))
    |> Enum.sort()
  end
end
