defmodule Vanta.MixProject do
  use Mix.Project

  def project do
    [
      app: :vanta,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto, :inets, :ssl]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:ex_json_schema, "~> 0.10"}
    ]
  end

  defp aliases do
    [
      "vanta.post_stage_1_larger_sample": ["vanta.post_stage1_larger_sample"],
      "vanta.post_stage_1_lane_b_packet": ["vanta.post_stage1_lane_b_packet"],
      "vanta.post_stage_1_lane_b_label_results": ["vanta.post_stage1_lane_b_label_results"],
      "vanta.post_stage_1_side_effect_planning": [
        "vanta.post_stage1_side_effect_planning"
      ]
    ]
  end
end
