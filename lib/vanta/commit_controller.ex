defmodule Vanta.CommitController do
  @moduledoc """
  Applies the Stage 1 commit rule for fixture-local actions.
  """

  alias Vanta.{StateManager, VerifierRuntime}

  def commit(state, step, evidence, verifier_output) do
    cond do
      verifier_output["decision"] != "accept" ->
        {:error, :verifier_not_accept}

      step["side_effect_class"] not in Vanta.allowed_side_effect_classes() ->
        {:error, :side_effect_class_not_allowed}

      VerifierRuntime.missing_evidence_fields(evidence) != [] ->
        {:error, :missing_evidence}

      step["side_effect_class"] == "REVERSIBLE" and
          not Map.has_key?(evidence["observation"], "backup_metadata") ->
        {:error, :missing_rollback_metadata}

      true ->
        committed_state =
          StateManager.append_event(state, event_from(step, evidence["observation"]))

        if committed_state["state_hash"] == evidence["post_state_hash"] do
          {:ok, committed_state}
        else
          {:error, :post_state_hash_mismatch}
        end
    end
  end

  defp event_from(step, observation) do
    %{
      "step_id" => step["step_id"],
      "action_type" => step["action_type"],
      "observation_kind" => observation["kind"],
      "mutated" => Map.get(observation, "mutated", false)
    }
  end
end
