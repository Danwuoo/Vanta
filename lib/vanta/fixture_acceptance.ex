defmodule Vanta.FixtureAcceptance do
  @moduledoc """
  Deterministic Stage 1 fixture-specific acceptance checks.
  """

  alias Vanta.Schema

  def load(workspace) do
    path = Path.join(workspace, "expected/acceptance.json")

    if File.exists?(path) do
      acceptance = Schema.load_json!(path)
      Schema.validate!("fixture_acceptance", acceptance)
    else
      %{}
    end
  end

  def action_sequence(workspace) do
    case load(workspace) do
      %{"action_sequence" => action_sequence} -> {:ok, action_sequence}
      _acceptance -> {:error, :missing_fixture_action_sequence}
    end
  end

  def expected_runtime_status(workspace) do
    workspace
    |> load()
    |> Map.get("expected_runtime_status")
  end

  def expected_task_success(workspace) do
    workspace
    |> load()
    |> Map.get("expected_task_success")
  end

  def evaluate_task(workspace, runtime_status, invalid_actions, observations) do
    acceptance = load(workspace)
    expected_status = Map.get(acceptance, "expected_runtime_status")

    observation_errors =
      observations
      |> Enum.map(&evaluate_observation(workspace, &1))
      |> Enum.filter(&match?({:error, _reason}, &1))

    status_ok? = is_nil(expected_status) or expected_status == runtime_status
    expected_success = Map.get(acceptance, "expected_task_success", status_ok?)

    cond do
      expected_success == false ->
        false

      not is_nil(expected_status) and expected_status != "committed" ->
        status_ok?

      observation_errors != [] ->
        false

      runtime_status == "committed" ->
        status_ok? and invalid_actions == 0

      true ->
        status_ok?
    end
  end

  def evaluate_observation(workspace, %{"kind" => "validate_artifact"} = observation) do
    case observation["validation"] do
      "traceability_links" ->
        expected_json(workspace, "traceability.json")
        |> compare_expected_key(observation, "links", "traceability_links_mismatch")

      "terminology_consistency" ->
        expected_json(workspace, "inconsistencies.json")
        |> compare_expected_key(
          observation,
          "inconsistencies",
          "terminology_inconsistencies_mismatch"
        )

      _other ->
        :not_applicable
    end
  end

  def evaluate_observation(workspace, %{"kind" => kind} = observation)
      when kind in ["simulate_patch", "compute_diff", "apply_reversible_patch"] do
    diff_path = Path.join(workspace, "expected/diff.txt")

    if File.exists?(diff_path) do
      expected = diff_path |> File.read!() |> trim_newline()
      actual = observation |> Map.get("diff", "") |> trim_newline()

      if expected == actual do
        :ok
      else
        {:error, "diff_mismatch"}
      end
    else
      :not_applicable
    end
  end

  def evaluate_observation(_workspace, _observation), do: :not_applicable

  defp expected_json(workspace, file_name) do
    path = Path.join(workspace, Path.join("expected", file_name))

    if File.exists?(path) do
      {:ok, Schema.load_json!(path)}
    else
      :missing
    end
  end

  defp compare_expected_key({:ok, expected}, observation, key, reason) do
    if Map.get(expected, key) == Map.get(observation, key) do
      :ok
    else
      {:error, reason}
    end
  end

  defp compare_expected_key(:missing, _observation, _key, _reason), do: :not_applicable

  defp trim_newline(value) when is_binary(value), do: String.trim_trailing(value)
end
