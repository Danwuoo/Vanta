defmodule Vanta.DocumentationClosureConsistencyTest do
  use ExUnit.Case, async: true

  @docs_root Path.expand("../../docs", __DIR__)
  @closure_doc Path.join(@docs_root, "00_manifest/Stage_1_Experiment_005_Closure.md")

  @phase5_status_docs [
    "04_experiments/Ablation_Plan.md",
    "06_engineering/Runtime_Module_Plan.md",
    "06_engineering/Implementation_Timeline.md",
    "00_manifest/Stage_1_Experiment_005_Closure.md",
    "05_evaluation/Experiment_005_Local_Run_Report.md"
  ]

  @phase5_runtime_modules [
    "Working Set Compiler",
    "Raw Trace Context Builder",
    "OpenClaw Context Planner Adapter"
  ]

  test "Phase 5 docs do not drift back to planned after Experiment 005 closure" do
    assert File.exists?(@closure_doc)

    closure_text = File.read!(@closure_doc)
    assert closure_text =~ "Status: `Closed: local smoke completed`"
    assert closure_text =~ "Closure date: 2026-05-07"

    docs = read_phase5_status_docs()
    ablation_plan = Map.fetch!(docs, "04_experiments/Ablation_Plan.md")
    runtime_plan = Map.fetch!(docs, "06_engineering/Runtime_Module_Plan.md")
    timeline = Map.fetch!(docs, "06_engineering/Implementation_Timeline.md")

    refute Regex.match?(~r/\|\s*E\s*\|\s*Planned\s*\|/, ablation_plan),
           "Ablation Plan Stage E still has Planned status"

    Enum.each(@phase5_runtime_modules, fn module_name ->
      refute Regex.match?(
               ~r/\|\s*#{Regex.escape(module_name)}\s*\|[^\n]*\|\s*Planned\b/,
               runtime_plan
             ),
             "Runtime Module Plan still marks #{module_name} as Planned"
    end)

    timeline
    |> markdown_section("## Phase 5: Context OS Candidate")
    |> then(fn phase5_section ->
      refute Regex.match?(~r/Status:\s*`?Planned`?/, phase5_section),
             "Implementation Timeline Phase 5 still has Planned status"
    end)
  end

  test "primary Phase 5 status surfaces point at the measured local smoke closure" do
    ablation_plan = File.read!(Path.join(@docs_root, "04_experiments/Ablation_Plan.md"))
    runtime_plan = File.read!(Path.join(@docs_root, "06_engineering/Runtime_Module_Plan.md"))
    timeline = File.read!(Path.join(@docs_root, "06_engineering/Implementation_Timeline.md"))
    report = File.read!(Path.join(@docs_root, "05_evaluation/Experiment_005_Local_Run_Report.md"))

    assert ablation_plan =~
             "| E | Local smoke evidence | Experiment 005 closed the five-fixture `Working Set Compiler v0` smoke against bounded raw trace; this is not broad validation of H3 or full Context OS. |"

    assert runtime_plan =~
             "| Working Set Compiler | Compile schema-valid, reference-backed `WorkingSet` artifacts from explicit candidate refs under a fixed budget. | Implemented and exercised by Experiment 005 local smoke |"

    assert runtime_plan =~
             "| Raw Trace Context Builder | Build bounded raw-trace baseline context under the same budget as treatment. | Implemented and exercised by Experiment 005 baseline local smoke |"

    assert runtime_plan =~
             "| OpenClaw Context Planner Adapter | Ask OpenClaw for JSON action sequences using embedded baseline or working-set context only. | Implemented and exercised by Experiment 005 local smoke |"

    assert timeline =~ "Status: `Closed: local smoke completed` on 2026-05-07."
    assert report =~ "Date: 2026-05-07"
    assert report =~ "The run provides a measured local smoke result for `Working Set Compiler v0`."
  end

  defp read_phase5_status_docs do
    Map.new(@phase5_status_docs, fn relative_path ->
      {relative_path, File.read!(Path.join(@docs_root, relative_path))}
    end)
  end

  defp markdown_section(text, heading) do
    [_before, rest] = String.split(text, heading, parts: 2)

    rest
    |> String.split(~r/\n## /, parts: 2)
    |> hd()
  end
end
