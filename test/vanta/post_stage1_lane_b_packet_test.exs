defmodule Vanta.PostStage1LaneBPacketTest do
  use ExUnit.Case

  alias Vanta.PostStage1LaneBPacket

  @opts [
    run_timestamp: "20260601_113121",
    run_json: "docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/run.json",
    run_report: "docs/05_evaluation/Post_Stage_1_Lane_A_20260601_113121_Run_Report.md",
    closure: "docs/00_manifest/Post_Stage_1_Lane_A_20260601_113121_Closure.md",
    fixtures: "docs/04_experiments/fixtures/document_ops",
    out: "docs/05_evaluation/label_packets/post_stage_1_lane_b_20260601_113121"
  ]

  test "builds active Lane B packet item counts and source linkage" do
    assert {:ok, packet} = PostStage1LaneBPacket.build(@opts)

    assert packet.packet_manifest["packet_id"] == "PS1-LB-PACKET-20260601-113121-BATCH-001"
    assert packet.packet_manifest["label_collection_status"] == "Not yet run"

    assert get_in(packet.packet_manifest, ["source_run", "closure_status"]) ==
             "accepted_by_closure"

    assert get_in(packet.packet_manifest, ["source_run", "run_json_path"]) ==
             "docs/04_experiments/results/post_stage_1_larger_sample/20260601_113121/run.json"

    assert length(packet.evidence_sufficiency_items) == 8
    assert length(packet.working_set_context_items) == 12
  end

  test "redacts oracle-sensitive task fields for primary labeler packets" do
    assert {:ok, packet} = PostStage1LaneBPacket.build(@opts)

    Enum.each(packet.redacted_task_packets, fn {_task_id, task_packet} ->
      refute has_key_recursive?(task_packet, "required_refs")
      refute has_key_recursive?(task_packet, "relevant_refs")
      refute has_key_recursive?(task_packet, "irrelevant_refs")
      refute has_key_recursive?(task_packet, "omission_trap_refs")
      refute has_key_recursive?(task_packet, "expected_runtime_status")
      refute has_key_recursive?(task_packet, "expected_label_source")

      Enum.each(task_packet["input_artifacts"], fn input_artifact ->
        refute Map.has_key?(input_artifact, "role")
        refute Map.has_key?(input_artifact, "description")
      end)
    end)
  end

  test "keeps all generated label fields Not yet run" do
    assert {:ok, packet} = PostStage1LaneBPacket.build(@opts)

    items = packet.evidence_sufficiency_items ++ packet.working_set_context_items

    Enum.each(items, fn item ->
      assert item["label_status"] == "Not yet run"
      assert item["adjudication_status"] == "Not yet run"
      assert Enum.all?(Map.values(item["primary_label_fields"]), &(&1 == "Not yet run"))
    end)
  end

  test "working-set context items use blinded arms without arm identity mapping" do
    assert {:ok, packet} = PostStage1LaneBPacket.build(@opts)

    assert Enum.frequencies_by(packet.working_set_context_items, & &1["blinded_arm"]) == %{
             "context_arm_A" => 6,
             "context_arm_B" => 6
           }

    encoded = Jason.encode!(packet.working_set_context_items)
    refute String.contains?(encoded, "\"baseline\"")
    refute String.contains?(encoded, "\"treatment\"")
  end

  test "selector-missing evidence item comes from repaired rejection artifact" do
    assert {:ok, packet} = PostStage1LaneBPacket.build(@opts)

    item =
      Enum.find(packet.evidence_sufficiency_items, fn item ->
        item["task_id"] == "docops_struct_selector_missing_001"
      end)

    assert item["packet_id"] == "lb20260601-es-005"
    assert get_in(item, ["action_under_review", "status"]) == "rejected"
    assert get_in(item, ["verifier_output", "decision"]) == "reject"

    assert get_in(item, ["evidence_packet", "observation", "selector_resolution", "status"]) ==
             "missing"

    assert get_in(item, ["action_under_review", "action_payload", "selector", "type"]) ==
             "section"
  end

  defp has_key_recursive?(map, key) when is_map(map) do
    Map.has_key?(map, key) or Enum.any?(Map.values(map), &has_key_recursive?(&1, key))
  end

  defp has_key_recursive?(list, key) when is_list(list) do
    Enum.any?(list, &has_key_recursive?(&1, key))
  end

  defp has_key_recursive?(_value, _key), do: false
end
