defmodule Vanta.Runtime do
  @moduledoc """
  Stage 1 closed-loop runtime orchestration.
  """

  alias Vanta.{
    ActionExecutor,
    CommitController,
    EpisodeJournal,
    EvidenceBuilder,
    ExecutionIRCompiler,
    FixtureAcceptance,
    PlannerAdapter,
    StateManager,
    VerifierRuntime
  }

  def run_task(task, source_workspace, opts \\ []) do
    workspace = prepare_workspace(source_workspace, opts)
    episode_id = Keyword.get(opts, :episode_id, "episode_#{Map.fetch!(task, "task_id")}")

    with {:ok, action_sequence} <- action_sequence(task, workspace, opts) do
      initial_state = StateManager.from_task(task)

      initial_acc = %{
        state: initial_state,
        journal:
          task
          |> EpisodeJournal.new(episode_id)
          |> EpisodeJournal.record_state(initial_state),
        steps: [],
        evidence_packets: [],
        verifier_outputs: [],
        observations: [],
        invalid_actions: 0,
        rollback_status: "not_applicable",
        status: "committed",
        stop?: false
      }

      acc =
        Enum.reduce_while(action_sequence["actions"], initial_acc, fn action, acc ->
          case run_action(task, workspace, episode_id, action, acc) do
            %{stop?: true} = next_acc -> {:halt, next_acc}
            next_acc -> {:cont, next_acc}
          end
        end)

      journal =
        acc.journal
        |> EpisodeJournal.set_commit_status(acc.status)
        |> EpisodeJournal.set_rollback_status(acc.rollback_status)
        |> EpisodeJournal.validate!()

      task_success? =
        FixtureAcceptance.evaluate_task(
          workspace,
          acc.status,
          acc.invalid_actions,
          acc.observations
        )

      {:ok,
       %{
         arm: :treatment,
         task: task,
         workspace: workspace,
         episode_id: episode_id,
         action_sequence: action_sequence,
         state: acc.state,
         steps: acc.steps,
         evidence_packets: acc.evidence_packets,
         verifier_outputs: acc.verifier_outputs,
         journal: journal,
         observations: acc.observations,
         total_actions: length(action_sequence["actions"]),
         invalid_actions: acc.invalid_actions,
         status: acc.status,
         rollback_status: acc.rollback_status,
         task_success?: task_success?
       }}
    end
  end

  defp action_sequence(task, workspace, opts) do
    cond do
      Keyword.has_key?(opts, :action_sequence) ->
        PlannerAdapter.propose_actions(task, workspace,
          action_sequence: Keyword.fetch!(opts, :action_sequence)
        )

      Keyword.has_key?(opts, :planner) ->
        planner = Keyword.fetch!(opts, :planner)
        planner.propose_actions(task, workspace, opts)

      true ->
        FixtureAcceptance.action_sequence(workspace)
    end
  end

  defp run_action(task, workspace, episode_id, action, acc) do
    action_type = action["action_type"]
    payload = action["action_payload"]

    case ExecutionIRCompiler.compile(task, episode_id, action_type, payload) do
      {:ok, step} ->
        execute_and_verify(task, workspace, step, acc)

      {:error, reason} ->
        rejected_step =
          ExecutionIRCompiler.rejected_step(task, episode_id, action_type, payload, reason)

        failure_observation = %{
          "kind" => action_type,
          "error" => inspect(reason),
          "mutated" => false
        }

        evidence = EvidenceBuilder.build(acc.state, rejected_step, failure_observation)

        verifier_output =
          VerifierRuntime.verify(rejected_step, evidence, %{
            task: task,
            workspace: workspace,
            compile_error: reason
          })

        %{
          acc
          | steps: acc.steps ++ [rejected_step],
            journal:
              acc.journal
              |> EpisodeJournal.record_step(rejected_step)
              |> EpisodeJournal.record_evidence(evidence)
              |> EpisodeJournal.record_verifier_output(verifier_output),
            evidence_packets: acc.evidence_packets ++ [evidence],
            verifier_outputs: acc.verifier_outputs ++ [verifier_output],
            observations: acc.observations ++ [failure_observation],
            invalid_actions: acc.invalid_actions + 1,
            status: "rejected",
            stop?: true
        }
    end
  end

  defp execute_and_verify(task, workspace, step, acc) do
    case safe_execute(workspace, step) do
      {:ok, observation} ->
        evidence = EvidenceBuilder.build(acc.state, step, observation)

        verifier_output =
          VerifierRuntime.verify(step, evidence, %{
            task: task,
            workspace: workspace,
            observations: acc.observations ++ [observation]
          })

        next_journal =
          acc.journal
          |> EpisodeJournal.record_step(step_with_status(step, verifier_output["decision"]))
          |> EpisodeJournal.record_evidence(evidence)
          |> EpisodeJournal.record_verifier_output(verifier_output)

        next_acc = %{
          acc
          | journal: next_journal,
            steps: acc.steps ++ [step_with_status(step, verifier_output["decision"])],
            evidence_packets: acc.evidence_packets ++ [evidence],
            verifier_outputs: acc.verifier_outputs ++ [verifier_output],
            observations: acc.observations ++ [observation]
        }

        handle_verifier_decision(
          workspace,
          step,
          evidence,
          verifier_output,
          observation,
          next_acc
        )

      {:error, reason} ->
        failure_observation = %{
          "kind" => step["action_type"],
          "error" => inspect(reason),
          "mutated" => false
        }

        evidence = EvidenceBuilder.build(acc.state, step, failure_observation)

        verifier_output =
          VerifierRuntime.verify(step, evidence, %{task: task, workspace: workspace})

        failed_step = Map.put(step, "status", "failed")

        %{
          acc
          | journal:
              acc.journal
              |> EpisodeJournal.record_step(failed_step)
              |> EpisodeJournal.record_evidence(evidence)
              |> EpisodeJournal.record_verifier_output(verifier_output),
            steps: acc.steps ++ [failed_step],
            evidence_packets: acc.evidence_packets ++ [evidence],
            verifier_outputs: acc.verifier_outputs ++ [verifier_output],
            observations: acc.observations ++ [failure_observation],
            invalid_actions: acc.invalid_actions + 1,
            status: "rejected",
            stop?: true
        }
    end
  end

  defp handle_verifier_decision(workspace, step, evidence, verifier_output, observation, acc) do
    if verifier_output["decision"] == "accept" do
      case CommitController.commit(acc.state, step, evidence, verifier_output) do
        {:ok, committed_state} ->
          %{
            acc
            | state: committed_state,
              journal: EpisodeJournal.record_state(acc.journal, committed_state),
              rollback_status: rollback_status_after_commit(step, acc.rollback_status)
          }

        {:error, reason} ->
          %{
            acc
            | invalid_actions: acc.invalid_actions + 1,
              status: "rejected",
              stop?: true,
              steps: mark_last_step(acc.steps, "rejected", inspect(reason))
          }
      end
    else
      rollback_status = rollback_if_needed(workspace, step, observation)

      %{
        acc
        | invalid_actions: acc.invalid_actions + 1,
          rollback_status: rollback_status,
          status: "rejected",
          stop?: true
      }
    end
  end

  defp safe_execute(workspace, step) do
    ActionExecutor.execute(workspace, step)
  rescue
    error -> {:error, {:execution_exception, Exception.message(error)}}
  end

  defp rollback_if_needed(workspace, %{"side_effect_class" => "REVERSIBLE"}, %{
         "backup_metadata" => metadata
       }) do
    case ActionExecutor.rollback(workspace, metadata) do
      :ok -> "completed"
      _other -> "failed"
    end
  rescue
    _error -> "failed"
  end

  defp rollback_if_needed(_workspace, %{"side_effect_class" => "REVERSIBLE"}, _observation),
    do: "unavailable"

  defp rollback_if_needed(_workspace, _step, _observation), do: "not_applicable"

  defp rollback_status_after_commit(%{"side_effect_class" => "REVERSIBLE"}, _status),
    do: "available"

  defp rollback_status_after_commit(_step, status), do: status

  defp step_with_status(step, "accept"), do: Map.put(step, "status", "committed")
  defp step_with_status(step, "request_evidence"), do: Map.put(step, "status", "aborted")
  defp step_with_status(step, _decision), do: Map.put(step, "status", "rejected")

  defp mark_last_step([], _status, _error), do: []

  defp mark_last_step(steps, status, error) do
    {prefix, [last]} = Enum.split(steps, -1)
    prefix ++ [last |> Map.put("status", status) |> Map.put("error", error)]
  end

  defp prepare_workspace(source_workspace, opts) do
    if Keyword.get(opts, :copy_workspace?, true) do
      target =
        Path.join(
          System.tmp_dir!(),
          "vanta_runtime_#{Path.basename(source_workspace)}_#{System.unique_integer([:positive])}"
        )

      File.rm_rf!(target)
      File.cp_r!(source_workspace, target)
      target
    else
      source_workspace
    end
  end
end
