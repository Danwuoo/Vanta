defmodule Vanta.EvaluationHarness do
  @moduledoc """
  Computes minimal process-integrity checks from Stage 1 episode journals.
  """

  @audit_fields ~w(
    schema_version
    episode_id
    task_id
    runtime_manifest
    steps
    state_hashes
    evidence_refs
    verifier_output_refs
    commit_status
    rollback_status
    memory_write_effects
  )

  def audit_complete?(journal) do
    Enum.all?(@audit_fields, &Map.has_key?(journal, &1))
  end

  def metrics(journals) do
    total = max(length(journals), 1)
    complete = Enum.count(journals, &audit_complete?/1)
    committed = Enum.count(journals, &(&1["commit_status"] == "committed"))

    %{
      "audit_completeness" => complete / total,
      "commit_integrity_score" => committed / total
    }
  end
end
