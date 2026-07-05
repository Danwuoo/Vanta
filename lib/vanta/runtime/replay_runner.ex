defmodule Vanta.ReplayRunner do
  @moduledoc """
  Replays Stage 1 episode journals against a clean fixture workspace.
  """

  alias Vanta.Runtime

  def replay(task, source_workspace, journal, artifacts \\ %{}, opts \\ []) do
    action_sequence = %{
      "actions" =>
        journal
        |> Map.get("steps", [])
        |> Enum.filter(&Map.has_key?(&1, "action_type"))
        |> Enum.map(fn step ->
          %{
            "action_type" => step["action_type"],
            "action_payload" => Map.get(step, "action_payload", %{})
          }
        end)
    }

    replay_episode_id = Keyword.get(opts, :episode_id, journal["episode_id"])

    case Runtime.run_task(task, source_workspace,
           action_sequence: action_sequence,
           episode_id: replay_episode_id
         ) do
      {:ok, result} ->
        expected_last_hash = journal |> Map.get("state_hashes", []) |> List.last()
        actual_last_hash = result.journal |> Map.get("state_hashes", []) |> List.last()
        expected_status = journal["commit_status"]
        actual_status = result.status
        expected_step_count = journal |> Map.get("steps", []) |> length()
        actual_step_count = result.journal |> Map.get("steps", []) |> length()
        expected_observation_signatures = observation_signatures(journal, artifacts)

        actual_observation_signatures =
          observation_signatures(result.journal, %{
            evidence_packets: result.evidence_packets
          })

        status_match? = actual_status == expected_status
        state_hash_match? = is_nil(expected_last_hash) or expected_last_hash == actual_last_hash
        step_count_match? = expected_step_count == actual_step_count

        observation_match? =
          expected_observation_signatures == [] or
            expected_observation_signatures == actual_observation_signatures

        consistent? =
          status_match? and state_hash_match? and step_count_match? and observation_match?

        {:ok,
         %{
           consistent?: consistent?,
           replay_result: result,
           expected_commit_status: expected_status,
           actual_commit_status: actual_status,
           expected_state_hash: expected_last_hash,
           actual_state_hash: actual_last_hash,
           expected_step_count: expected_step_count,
           actual_step_count: actual_step_count,
           status_match?: status_match?,
           state_hash_match?: state_hash_match?,
           step_count_match?: step_count_match?,
           observation_match?: observation_match?
         }}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp observation_signatures(journal, artifacts) do
    evidence_by_id =
      artifacts
      |> artifact_list(:evidence_packets)
      |> Map.new(&{&1["evidence_id"], &1})

    journal
    |> Map.get("evidence_refs", [])
    |> Enum.flat_map(fn ref ->
      case Map.fetch(evidence_by_id, ref) do
        {:ok, evidence} -> [observation_signature(evidence["observation"])]
        :error -> []
      end
    end)
  end

  defp observation_signature(observation) do
    %{
      "kind" => observation["kind"],
      "path" => observation["path"],
      "selector_status" => get_in(observation, ["selector_resolution", "status"]),
      "diff" => observation["diff"],
      "before_hash" => observation["before_hash"],
      "after_hash" => observation["after_hash"],
      "passed" => observation["passed"],
      "failures" => observation["failures"]
    }
  end

  defp artifact_list(artifacts, key) do
    Map.get(artifacts, key) || Map.get(artifacts, Atom.to_string(key)) || []
  end
end
