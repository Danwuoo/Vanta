defmodule Vanta do
  @moduledoc """
  Stage 1 MVP runtime skeleton for fixture-local Document Ops tasks.
  """

  @schema_version "stage1-mvp-v0"
  @persistence_schema_version "persistence-v0"
  @hash_policy_version "canonical-json-sha256-v1"
  @allowed_side_effect_classes ~w(READ_ONLY SIMULATED REVERSIBLE COMPENSABLE)
  @action_types ~w(
    read_file
    list_files
    compute_hash
    inspect_document_structure
    validate_document_contract
    simulate_structured_edit
    apply_reversible_structured_edit
    simulate_patch
    compute_diff
    apply_reversible_patch
    record_compensable_action
    validate_artifact
  )

  def schema_version, do: @schema_version

  def persistence_schema_version, do: @persistence_schema_version

  def hash_policy_version, do: @hash_policy_version

  def allowed_side_effect_classes, do: @allowed_side_effect_classes

  def action_types, do: @action_types
end
