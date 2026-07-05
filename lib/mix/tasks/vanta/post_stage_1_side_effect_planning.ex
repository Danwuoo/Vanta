defmodule Mix.Tasks.Vanta.PostStage1SideEffectPlanning do
  @moduledoc """
  Generates the PS1-G8 side-effect planning-only scaffold artifacts.
  """

  use Mix.Task

  @shortdoc "Generate PS1-G8 side-effect planning scaffold"

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    {opts, _argv, _invalid} =
      OptionParser.parse(args,
        strict: [
          out: :string,
          timestamp: :string
        ]
      )

    runner_opts =
      compact_opts(
        out_dir: Keyword.get(opts, :out),
        timestamp: Keyword.get(opts, :timestamp)
      )

    {:ok, run} = Vanta.PostStage1SideEffectPlanning.generate(runner_opts)

    Mix.shell().info(
      "PS1-G8 side-effect planning scaffold #{run["run_status"]}; runtime execution #{run["runtime_execution_status"]}."
    )

    Mix.shell().info("Results: #{run["artifact_root"]}")
  end

  defp compact_opts(opts) do
    Enum.reject(opts, fn {_key, value} -> is_nil(value) end)
  end
end
