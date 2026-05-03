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

        consistent? =
          result.status == journal["commit_status"] and
            (is_nil(expected_last_hash) or expected_last_hash == actual_last_hash)

        {:ok,
         %{
           consistent?: consistent?,
           replay_result: result,
           expected_state_hash: expected_last_hash,
           actual_state_hash: actual_last_hash
         }}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
