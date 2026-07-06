defmodule Vanta.OpenClawAdapterIdentityTest do
  use ExUnit.Case, async: true

  @moduletag :fast_unit

  alias Vanta.{
    OpenClawContextPlannerAdapter,
    OpenClawPlannerAdapter,
    OpenClawRecoveryAdapter,
    OpenClawVerifierAdapter
  }

  @opts [
    wsl_executable: "mock-wsl",
    openclaw_dir: "~/openclaw",
    model: "test-model"
  ]

  test "preserves OpenClaw adapter arm identities" do
    assert OpenClawPlannerAdapter.baseline_id(@opts) ==
             "openclaw_agent_local/openai-codex/test-model_direct_execution"

    assert OpenClawContextPlannerAdapter.planner_id(@opts) ==
             "openclaw_agent_local/openai-codex/test-model"

    assert OpenClawRecoveryAdapter.recovery_id(@opts) ==
             "openclaw_agent_local/openai-codex/test-model"

    assert OpenClawVerifierAdapter.verifier_id(@opts) ==
             "openclaw_agent_local/openai-codex/test-model_verifier"
  end
end
