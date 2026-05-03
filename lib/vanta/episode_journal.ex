defmodule Vanta.EpisodeJournal do
  @moduledoc """
  Persists audit and replay metadata for a Stage 1 fixture episode.
  """

  def new(task, episode_id \\ nil) do
    episode_id = episode_id || "episode_#{Map.fetch!(task, "task_id")}"

    %{
      "schema_version" => Vanta.schema_version(),
      "episode_id" => episode_id,
      "task_id" => Map.fetch!(task, "task_id"),
      "runtime_manifest" => %{
        "runtime" => "vanta_phase1",
        "language" => "elixir",
        "schema_version" => Vanta.schema_version()
      },
      "steps" => [],
      "state_hashes" => [],
      "evidence_refs" => [],
      "verifier_output_refs" => [],
      "commit_status" => "not_started",
      "rollback_status" => "not_applicable",
      "memory_write_effects" => []
    }
  end

  def record_state(journal, state) do
    update_in(journal, ["state_hashes"], &append_unique(&1, state["state_hash"]))
  end

  def record_step(journal, step) do
    update_in(journal, ["steps"], &(&1 ++ [step]))
  end

  def record_evidence(journal, evidence) do
    update_in(journal, ["evidence_refs"], &append_unique(&1, evidence["evidence_id"]))
  end

  def record_verifier_output(journal, verifier_output) do
    update_in(
      journal,
      ["verifier_output_refs"],
      &append_unique(&1, verifier_output["verifier_output_id"])
    )
  end

  def set_commit_status(journal, status), do: Map.put(journal, "commit_status", status)
  def set_rollback_status(journal, status), do: Map.put(journal, "rollback_status", status)

  def validate!(journal), do: Vanta.Schema.validate!("episode_journal", journal)

  defp append_unique(values, value), do: Enum.uniq(values ++ [value])
end
