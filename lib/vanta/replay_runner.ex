defmodule Vanta.ReplayRunner do
  @moduledoc """
  Replays Stage 1 episode journals against a clean fixture workspace.
  """

  alias Vanta.Runtime

  def replay(task, source_workspace, journal, _artifacts \\ %{}, opts \\ []) do
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

        status_match? = actual_status == expected_status
        state_hash_match? = is_nil(expected_last_hash) or expected_last_hash == actual_last_hash
        step_count_match? = expected_step_count == actual_step_count

        consistent? =
          status_match? and state_hash_match? and step_count_match?

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
           step_count_match?: step_count_match?
         }}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
