defmodule Mix.Tasks.Vanta.PostStage1LaneBLabelResults do
  @moduledoc """
  Generates or validates Post-Stage-1 Lane B label result imports.
  """

  use Mix.Task

  @shortdoc "Generate or validate Post-Stage-1 Lane B label results"

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    {opts, _argv, invalid} =
      OptionParser.parse(args,
        strict: [
          mode: :string,
          run_timestamp: :string,
          packet_dir: :string,
          results: :string,
          out: :string
        ]
      )

    if invalid != [] do
      Mix.raise("Invalid options: #{inspect(invalid)}")
    end

    mode = Keyword.get(opts, :mode, "validate")
    packet_opts = compact_opts(opts)

    case mode do
      "template" ->
        out = Keyword.get(opts, :out, default_template_path(opts))

        case Vanta.PostStage1LaneBLabelResults.write_template(out, packet_opts) do
          {:ok, result} ->
            Mix.shell().info(
              "Lane B label result template written: #{result["path"] || result.path}"
            )

            Mix.shell().info("Packet: #{result.packet_id}")
            Mix.shell().info("Result format: #{result.result_format}")
            Mix.shell().info("Label collection status: #{result.label_collection_status}")

          {:error, errors} ->
            Mix.raise("Lane B label result template generation failed:\n#{format_errors(errors)}")
        end

      "validate" ->
        results_path = required_results!(opts, mode)

        case Vanta.PostStage1LaneBLabelResults.validate_file(results_path, packet_opts) do
          {:ok, summary} ->
            print_summary("Lane B label result validation passed", summary)

          {:error, errors} ->
            Mix.raise("Lane B label result validation failed:\n#{format_errors(errors)}")
        end

      "import-summary" ->
        results_path = required_results!(opts, mode)

        case Keyword.get(opts, :out) do
          nil ->
            case Vanta.PostStage1LaneBLabelResults.validate_file(results_path, packet_opts) do
              {:ok, summary} ->
                print_summary("Lane B label result import summary", summary)

              {:error, errors} ->
                Mix.raise("Lane B label result import summary failed:\n#{format_errors(errors)}")
            end

          out ->
            case Vanta.PostStage1LaneBLabelResults.write_import_summary(
                   results_path,
                   out,
                   packet_opts
                 ) do
              {:ok, summary} ->
                print_summary("Lane B label result import summary written", summary)
                Mix.shell().info("Summary: #{summary["summary_path"]}")

              {:error, errors} ->
                Mix.raise("Lane B label result import summary failed:\n#{format_errors(errors)}")
            end
        end

      other ->
        Mix.raise(
          "Unsupported --mode #{inspect(other)}; expected template, validate, or import-summary"
        )
    end
  end

  defp compact_opts(opts) do
    opts
    |> Keyword.drop([:mode, :results, :out])
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
  end

  defp required_results!(opts, mode) do
    case Keyword.get(opts, :results) do
      nil -> Mix.raise("--results is required for --mode #{mode}")
      value -> value
    end
  end

  defp default_template_path(opts) do
    run_timestamp =
      Keyword.get(opts, :run_timestamp, Vanta.PostStage1LaneBPacket.default_run_timestamp())

    Keyword.get(
      opts,
      :packet_dir,
      "docs/05_evaluation/label_packets/post_stage_1_lane_b_#{run_timestamp}"
    )
    |> Path.join("label_results_template.json")
  end

  defp print_summary(title, summary) do
    Mix.shell().info("#{title}: #{summary["packet_id"]}")
    Mix.shell().info("Results: #{summary["result_path"]}")
    Mix.shell().info("Label collection status: #{summary["label_collection_status"]}")

    Mix.shell().info(
      "Raw evidence labels: #{summary["raw_label_counts"]["evidence_sufficiency_score"]}"
    )

    Mix.shell().info(
      "Raw working-set labels: #{summary["raw_label_counts"]["working_set_context"]}"
    )

    Mix.shell().info("Needs review count: #{summary["needs_review_count"]}")
    Mix.shell().info("Adjudication required: #{summary["adjudication_required_count"]}")

    Mix.shell().info(
      "Unhandled adjudication required: #{summary["unhandled_adjudication_required_count"]}"
    )
  end

  defp format_errors(errors) do
    errors
    |> List.wrap()
    |> Enum.map_join("\n", &"- #{&1}")
  end
end
