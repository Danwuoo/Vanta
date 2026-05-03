defmodule Vanta.SchemaContractTest do
  use ExUnit.Case, async: true

  alias Vanta.{
    ActionExecutor,
    EpisodeJournal,
    EvidenceBuilder,
    ExecutionIRCompiler,
    PlannerAdapter,
    Schema,
    StateManager,
    VerifierRuntime
  }

  @fixture_root Path.expand("../fixtures/document_ops", __DIR__)

  test "document ops task fixtures validate against benchmark and canonical state schemas" do
    @fixture_root
    |> Path.join("*/task.json")
    |> Path.wildcard()
    |> Enum.each(fn task_path ->
      task = Schema.load_json!(task_path)
      assert :ok = Schema.validate("benchmark_task", task)
      assert :ok = Schema.validate("canonical_state", task["initial_state"])
    end)
  end

  test "fixture acceptance files and planner action sequences validate against schemas" do
    @fixture_root
    |> Path.join("*/expected/acceptance.json")
    |> Path.wildcard()
    |> Enum.each(fn acceptance_path ->
      acceptance = Schema.load_json!(acceptance_path)
      assert :ok = Schema.validate("fixture_acceptance", acceptance)

      assert {:ok, _sequence} =
               PlannerAdapter.validate_action_sequence(acceptance["action_sequence"])
    end)
  end

  test "schemas reject missing required Stage 1 fields" do
    task =
      @fixture_root
      |> Path.join("docops_read_traceability_001/task.json")
      |> Schema.load_json!()

    invalid_task = Map.delete(task, "task_id")
    invalid_state = Map.delete(task["initial_state"], "state_hash")

    assert {:error, _errors} = Schema.validate("benchmark_task", invalid_task)
    assert {:error, _errors} = Schema.validate("canonical_state", invalid_state)
  end

  test "generated runtime artifacts validate against Stage 1 schemas" do
    workspace = Path.join(@fixture_root, "docops_simulate_patch_001")
    task = Schema.load_json!(Path.join(workspace, "task.json"))
    state = StateManager.from_task(task)
    episode_id = "episode_schema_contract"

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

    assert :ok = Schema.validate("execution_step", step)
    assert :ok = Schema.validate("evidence_packet", evidence)
    assert :ok = Schema.validate("verifier_output", verifier_output)
    assert :ok = Schema.validate("episode_journal", journal)
  end

  test "experiment run schema accepts compact measured run records" do
    run = %{
      "schema_version" => Vanta.schema_version(),
      "experiment_id" => "experiment_001_minimal_loop",
      "status" => "completed",
      "baseline" => "llm_action_sequence_direct_execution",
      "treatment" => "stage1_closed_loop_runtime",
      "fixture_count" => 0,
      "tasks" => [],
      "metrics" => %{}
    }

    assert :ok = Schema.validate("experiment_run", run)
  end
end
