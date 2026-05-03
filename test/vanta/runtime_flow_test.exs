defmodule Vanta.RuntimeFlowTest do
  use ExUnit.Case

  alias Vanta.{
    ActionExecutor,
    BaselineRunner,
    CommitController,
    EpisodeJournal,
    EvaluationHarness,
    EvidenceBuilder,
    ExecutionIRCompiler,
    Experiment001,
    FixtureAcceptance,
    OpenClawPlannerAdapter,
    OpenAIPlannerAdapter,
    ReplayRunner,
    Runtime,
    Schema,
    StateManager,
    VerifierRuntime
  }

  @fixture_root Path.expand("../fixtures/document_ops", __DIR__)

  test "verifier requests extra evidence when required evidence is missing" do
    {task, workspace} = load_fixture("docops_simulate_patch_001")
    state = StateManager.from_task(task)

    {:ok, step} =
      ExecutionIRCompiler.compile(task, "episode_missing_evidence", "simulate_patch", %{
        "path" => "inputs/spec.md",
        "find" => "First controlled environment: TBD.",
        "replace" => "First controlled environment: Document Ops."
      })

    {:ok, observation} = ActionExecutor.execute(workspace, step)

    evidence =
      state
      |> EvidenceBuilder.build(step, observation)
      |> Map.delete("observation")

    verifier_output = VerifierRuntime.verify(step, evidence)

    assert verifier_output["decision"] == "request_evidence"
    assert "observation" in verifier_output["required_extra_evidence"]
  end

  test "forbidden side-effect classes cannot enter the commit path" do
    {task, workspace} = load_fixture("docops_simulate_patch_001")
    state = StateManager.from_task(task)

    {:ok, step} =
      ExecutionIRCompiler.compile(task, "episode_forbidden", "simulate_patch", %{
        "path" => "inputs/spec.md",
        "find" => "First controlled environment: TBD.",
        "replace" => "First controlled environment: Document Ops."
      })

    {:ok, observation} = ActionExecutor.execute(workspace, step)
    forbidden_step = Map.put(step, "side_effect_class", "IRREVERSIBLE")
    evidence = EvidenceBuilder.build(state, forbidden_step, observation)
    verifier_output = VerifierRuntime.verify(forbidden_step, evidence)

    assert verifier_output["decision"] == "reject"

    assert {:error, :verifier_not_accept} =
             CommitController.commit(state, forbidden_step, evidence, verifier_output)
  end

  test "commit controller only commits verifier accept decisions" do
    {task, workspace} = load_fixture("docops_simulate_patch_001")
    state = StateManager.from_task(task)

    {:ok, step} =
      ExecutionIRCompiler.compile(task, "episode_commit_gate", "simulate_patch", %{
        "path" => "inputs/spec.md",
        "find" => "First controlled environment: TBD.",
        "replace" => "First controlled environment: Document Ops."
      })

    {:ok, observation} = ActionExecutor.execute(workspace, step)
    evidence = EvidenceBuilder.build(state, step, observation)
    verifier_output = VerifierRuntime.verify(step, evidence)

    assert verifier_output["decision"] == "accept"

    assert {:ok, committed_state} =
             CommitController.commit(state, step, evidence, verifier_output)

    assert committed_state["state_hash"] == evidence["post_state_hash"]

    rejected_output = Map.put(verifier_output, "decision", "reject")

    assert {:error, :verifier_not_accept} =
             CommitController.commit(state, step, evidence, rejected_output)
  end

  test "reversible edit writes backup metadata and can rollback in a fixture workspace" do
    workspace = copy_fixture("docops_reversible_edit_001")
    task = Schema.load_json!(Path.join(workspace, "task.json"))
    target = Path.join(workspace, "inputs/glossary.md")
    original = File.read!(target)

    {:ok, step} =
      ExecutionIRCompiler.compile(task, "episode_reversible", "apply_reversible_patch", %{
        "path" => "inputs/glossary.md",
        "find" => "Verifier Runtime: final-answer checker for a completed task.",
        "replace" =>
          "Verifier Runtime: runtime verifier for action feasibility, evidence sufficiency, and final correctness where applicable."
      })

    {:ok, observation} = ActionExecutor.execute(workspace, step)

    assert observation["mutated"] == true
    assert File.read!(target) != original
    assert File.exists?(Path.join(workspace, observation["backup_metadata"]["backup_path"]))
    assert File.exists?(Path.join(workspace, observation["backup_metadata"]["metadata_path"]))

    assert :ok = ActionExecutor.rollback(workspace, observation["backup_metadata"])
    assert File.read!(target) == original
  end

  test "episode journal records state, evidence, verifier, commit, and rollback status" do
    {task, workspace} = load_fixture("docops_simulate_patch_001")
    state = StateManager.from_task(task)
    episode_id = "episode_journal_records"

    {:ok, step} =
      ExecutionIRCompiler.compile(task, episode_id, "simulate_patch", %{
        "path" => "inputs/spec.md",
        "find" => "First controlled environment: TBD.",
        "replace" => "First controlled environment: Document Ops."
      })

    {:ok, observation} = ActionExecutor.execute(workspace, step)
    evidence = EvidenceBuilder.build(state, step, observation)
    verifier_output = VerifierRuntime.verify(step, evidence)

    journal =
      task
      |> EpisodeJournal.new(episode_id)
      |> EpisodeJournal.record_state(state)
      |> EpisodeJournal.record_step(step)
      |> EpisodeJournal.record_evidence(evidence)
      |> EpisodeJournal.record_verifier_output(verifier_output)
      |> EpisodeJournal.set_commit_status("committed")
      |> EpisodeJournal.set_rollback_status("not_applicable")
      |> EpisodeJournal.validate!()

    assert journal["state_hashes"] == [state["state_hash"]]
    assert journal["evidence_refs"] == [evidence["evidence_id"]]
    assert journal["verifier_output_refs"] == [verifier_output["verifier_output_id"]]
    assert journal["commit_status"] == "committed"
    assert journal["rollback_status"] == "not_applicable"
    assert EvaluationHarness.audit_complete?(journal)
  end

  test "runtime runs positive fixtures end-to-end and replay is consistent" do
    Enum.each(
      ~w(
        docops_read_traceability_001
        docops_detect_terms_001
        docops_simulate_patch_001
        docops_reversible_edit_001
      ),
      fn fixture_id ->
        {task, workspace} = load_fixture(fixture_id)

        assert {:ok, result} = Runtime.run_task(task, workspace)
        assert result.status == "committed"
        assert result.task_success?
        assert result.journal["commit_status"] == "committed"
        assert result.journal["rollback_status"] in ["not_applicable", "available"]

        Enum.each(result.evidence_packets, fn evidence ->
          assert :ok = Schema.validate("evidence_packet", evidence)
        end)

        Enum.each(result.verifier_outputs, fn verifier_output ->
          assert verifier_output["decision"] == "accept"
          assert :ok = Schema.validate("verifier_output", verifier_output)
        end)

        assert {:ok, replay} =
                 ReplayRunner.replay(task, workspace, result.journal, %{
                   evidence_packets: result.evidence_packets,
                   verifier_outputs: result.verifier_outputs
                 })

        assert replay.consistent?
      end
    )
  end

  test "runtime rejects negative fixtures and records invalid action paths" do
    Enum.each(
      ~w(
        docops_action_not_allowed_001
        docops_path_escape_001
        docops_wrong_diff_001
      ),
      fn fixture_id ->
        {task, workspace} = load_fixture(fixture_id)

        assert {:ok, result} = Runtime.run_task(task, workspace)
        assert result.status == "rejected"
        assert result.task_success?
        assert result.invalid_actions >= 1
        assert result.journal["commit_status"] == "rejected"

        assert {:ok, replay} = ReplayRunner.replay(task, workspace, result.journal, %{})
        assert replay.consistent?
      end
    )
  end

  test "verifier rejects simulated observations that mutate source state" do
    {task, workspace} = load_fixture("docops_simulate_patch_001")
    state = StateManager.from_task(task)

    {:ok, step} =
      ExecutionIRCompiler.compile(task, "episode_mutation_violation", "simulate_patch", %{
        "path" => "inputs/spec.md",
        "find" => "First controlled environment: TBD.",
        "replace" => "First controlled environment: Document Ops."
      })

    {:ok, observation} = ActionExecutor.execute(workspace, step)
    mutated_observation = Map.put(observation, "mutated", true)
    evidence = EvidenceBuilder.build(state, step, mutated_observation)
    verifier_output = VerifierRuntime.verify(step, evidence, %{workspace: workspace, task: task})

    assert verifier_output["decision"] == "reject"
    assert "simulated_action_mutated" in verifier_output["violated_constraints"]
  end

  test "baseline direct execution records invalid actions without governance artifacts" do
    {task, workspace} = load_fixture("docops_wrong_diff_001")
    {:ok, action_sequence} = FixtureAcceptance.action_sequence(workspace)

    assert {:ok, result} = BaselineRunner.run_task(task, workspace, action_sequence)
    assert result.arm == :baseline
    assert result.status == "invalid_actions"
    assert result.invalid_actions == 1
    assert result.task_success? == false
    refute Map.has_key?(result, :journal)
    refute Map.has_key?(result, :evidence_packets)
  end

  test "openai planner adapter parses mock structured output" do
    {task, workspace} = load_fixture("docops_read_traceability_001")

    client = fn request, env ->
      assert request["text"]["format"]["type"] == "json_schema"
      assert env.model == "test-model"

      {:ok,
       %{
         "output_text" =>
           Jason.encode!(%{
             "actions" => [
               %{
                 "action_type" => "validate_artifact",
                 "action_payload" => %{
                   "path" => "inputs/source.md",
                   "validation" => "traceability_links"
                 }
               }
             ]
           })
       }}
    end

    assert {:ok, action_sequence} =
             OpenAIPlannerAdapter.propose_actions(task, workspace,
               api_key: "test-key",
               model: "test-model",
               client: client
             )

    assert [%{"action_type" => "validate_artifact"}] = action_sequence["actions"]
  end

  test "openclaw planner adapter parses mock agent payload text" do
    {task, workspace} = load_fixture("docops_read_traceability_001")

    runner = fn prompt, env ->
      assert String.contains?(prompt, "non-interactive Vanta Experiment 001 planner")
      assert env.model == "openai-codex/gpt-5.4-mini"
      assert String.starts_with?(env.session_id, "vanta-exp001-docops_read_traceability_001-")

      {:ok,
       %{
         "payloads" => [
           %{
             "text" =>
               Jason.encode!(%{
                 "actions" => [
                   %{
                     "action_type" => "validate_artifact",
                     "action_payload" => %{
                       "path" => "inputs/source.md",
                       "validation" => "traceability_links"
                     }
                   }
                 ]
               })
           }
         ]
       }}
    end

    assert {:ok, action_sequence} =
             OpenClawPlannerAdapter.propose_actions(task, workspace,
               wsl_executable: "wsl.exe",
               model: "gpt-5.4-mini",
               runner: runner
             )

    assert [%{"action_type" => "validate_artifact"}] = action_sequence["actions"]
  end

  test "malformed action sequence is rejected before execution" do
    assert {:error, {:invalid_action_sequence, _errors}} =
             Vanta.PlannerAdapter.validate_action_sequence(%{
               "actions" => [%{"action_type" => "unknown", "action_payload" => %{}}]
             })
  end

  test "experiment runner writes compact mock run results" do
    out_dir =
      Path.join(System.tmp_dir!(), "vanta_experiment001_#{System.unique_integer([:positive])}")

    File.rm_rf!(out_dir)

    assert {:ok, run} =
             Experiment001.run(@fixture_root,
               planner: __MODULE__.AcceptancePlanner,
               out_dir: out_dir
             )

    assert run["status"] == "completed"
    assert run["fixture_count"] == 7
    assert :ok = Schema.validate("experiment_run", run)
    assert File.exists?(Path.join(out_dir, "run.json"))
    assert File.exists?(Path.join(out_dir, "summary.md"))
  end

  defp load_fixture(fixture_id) do
    workspace = Path.join(@fixture_root, fixture_id)
    {Schema.load_json!(Path.join(workspace, "task.json")), workspace}
  end

  defp copy_fixture(fixture_id) do
    source = Path.join(@fixture_root, fixture_id)

    target =
      Path.join(System.tmp_dir!(), "vanta_#{fixture_id}_#{System.unique_integer([:positive])}")

    File.rm_rf!(target)
    File.cp_r!(source, target)
    target
  end

  defmodule AcceptancePlanner do
    def propose_actions(_task, workspace, _opts),
      do: Vanta.FixtureAcceptance.action_sequence(workspace)
  end
end
