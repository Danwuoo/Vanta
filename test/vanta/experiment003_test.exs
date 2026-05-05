defmodule Vanta.Experiment003Test do
  use ExUnit.Case

  alias Vanta.{Experiment003, Schema}

  @fixture_root Path.expand("../fixtures/document_ops", __DIR__)

  test "experiment003 runner writes journal audit and replay smoke results" do
    out_dir =
      Path.join(System.tmp_dir!(), "vanta_experiment003_#{System.unique_integer([:positive])}")

    File.rm_rf!(out_dir)

    assert {:ok, run} = Experiment003.run(@fixture_root, out_dir: out_dir)

    assert run["status"] == "completed"
    assert run["fixture_count"] == 7
    assert :ok = Schema.validate("experiment_run", run)
    assert File.exists?(Path.join(out_dir, "run.json"))
    assert File.exists?(Path.join(out_dir, "summary.md"))

    assert run["metrics"]["baseline"]["commit_integrity_score"] == 0.0
    assert run["metrics"]["baseline"]["replay_consistency"] == 0.0
    assert run["metrics"]["baseline"]["audit_completeness"] == 0.0

    assert run["metrics"]["treatment"]["commit_integrity_score"] == 1.0
    assert run["metrics"]["treatment"]["replay_consistency"] == 1.0
    assert run["metrics"]["treatment"]["audit_completeness"] == 1.0
    assert run["metrics"]["treatment"]["invalid_action_rate"] == 3 / 7

    assert Enum.all?(run["tasks"], &get_in(&1, ["replay", "consistent"]))
    assert Enum.all?(run["tasks"], &get_in(&1, ["treatment", "audit_complete"]))
  end
end
