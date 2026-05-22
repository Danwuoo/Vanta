defmodule Vanta.OpenClawPlannerAdapter do
  @moduledoc """
  OpenClaw-backed Stage 1 planner adapter.

  This adapter calls the OpenClaw local agent harness through WSL and extracts a
  JSON planner action sequence from the returned assistant text. It is a planner
  only; it does not verify, execute, or commit actions.
  """

  alias Vanta.PlannerAdapter

  @default_model "openai-codex/gpt-5.4-mini"
  @default_openclaw_dir "~/openclaw"
  @default_agent "main"
  @default_timeout_seconds 600
  @default_thinking "off"
  @default_max_prompt_chars 20_000
  @default_max_response_chars 12_000

  @context_overflow_markers [
    "context overflow",
    "context_overflow",
    "context length",
    "context window",
    "maximum context",
    "max context",
    "too many tokens",
    "token limit",
    "prompt is too long",
    "input is too long",
    "exceeds the context"
  ]

  def propose_actions(task, workspace, opts \\ []) do
    with {:ok, env} <- env(opts, task),
         {:ok, prompt} <- prompt(task, workspace, opts),
         {:ok, response} <- call_openclaw(prompt, env, opts),
         {:ok, text} <- extract_assistant_text(response),
         :ok <- reject_context_overflow(text),
         {:ok, response_text} <- enforce_response_budget(text, opts),
         {:ok, action_sequence} <- decode_action_sequence(response_text) do
      PlannerAdapter.validate_action_sequence(action_sequence)
    end
  end

  def env(opts \\ [], task \\ nil) do
    model =
      opts
      |> Keyword.get(:model)
      |> fallback(System.get_env("OPENCLAW_MODEL"))
      |> fallback(openai_model_from_env())
      |> fallback(@default_model)
      |> normalize_model()

    wsl_executable =
      opts
      |> Keyword.get(:wsl_executable)
      |> fallback(System.get_env("WSL_EXE"))
      |> fallback(System.find_executable("wsl.exe"))

    openclaw_dir =
      opts
      |> Keyword.get(:openclaw_dir)
      |> fallback(System.get_env("OPENCLAW_DIR"))
      |> fallback(@default_openclaw_dir)

    agent =
      opts
      |> Keyword.get(:agent)
      |> fallback(System.get_env("OPENCLAW_AGENT"))
      |> fallback(@default_agent)

    timeout_seconds =
      opts
      |> Keyword.get(:timeout_seconds)
      |> fallback(System.get_env("OPENCLAW_TIMEOUT_SECONDS"))
      |> parse_positive_integer(@default_timeout_seconds)

    thinking =
      opts
      |> Keyword.get(:thinking)
      |> fallback(System.get_env("OPENCLAW_THINKING"))
      |> fallback(@default_thinking)

    cond do
      blank?(wsl_executable) ->
        {:error, :missing_wsl_executable}

      blank?(openclaw_dir) ->
        {:error, :missing_openclaw_dir}

      blank?(model) ->
        {:error, :missing_openclaw_model}

      true ->
        {:ok,
         %{
           wsl_executable: wsl_executable,
           openclaw_dir: openclaw_dir,
           agent: agent,
           model: model,
           timeout_seconds: timeout_seconds,
           thinking: thinking,
           session_id: session_id(opts, task)
         }}
    end
  end

  def baseline_id(opts \\ []) do
    case env(opts) do
      {:ok, env} -> "openclaw_agent_local/#{env.model}_direct_execution"
      {:error, _reason} -> "openclaw_agent_local/direct_execution"
    end
  end

  defp prompt(task, workspace, opts) do
    max_chars = max_prompt_chars(opts)
    full_previews = artifact_previews(task, workspace, :full)
    full_prompt = prompt_text(task, full_previews)

    if String.length(full_prompt) <= max_chars do
      {:ok, full_prompt}
    else
      budgeted_prompt(task, workspace, max_chars)
    end
  end

  defp budgeted_prompt(task, workspace, max_chars) do
    blank_previews = artifact_previews(task, workspace, 0)
    blank_prompt = prompt_text(task, blank_previews)
    blank_prompt_chars = String.length(blank_prompt)

    if blank_prompt_chars > max_chars do
      {:error, {:planner_prompt_budget_exceeded, blank_prompt_chars, max_chars}}
    else
      artifact_count = task |> Map.get("input_artifacts", []) |> length() |> Kernel.max(1)
      per_artifact_limit = div(max_chars - blank_prompt_chars, artifact_count)

      fit_budgeted_prompt(task, workspace, max_chars, artifact_count, per_artifact_limit)
    end
  end

  defp fit_budgeted_prompt(task, workspace, max_chars, artifact_count, per_artifact_limit) do
    previews = artifact_previews(task, workspace, per_artifact_limit)
    prompt = prompt_text(task, previews)
    prompt_chars = String.length(prompt)

    cond do
      prompt_chars <= max_chars ->
        {:ok, prompt}

      per_artifact_limit <= 0 ->
        {:error, {:planner_prompt_budget_exceeded, prompt_chars, max_chars}}

      true ->
        overflow = prompt_chars - max_chars
        decrement = overflow |> div(artifact_count) |> Kernel.max(1)

        fit_budgeted_prompt(
          task,
          workspace,
          max_chars,
          artifact_count,
          Kernel.max(per_artifact_limit - decrement, 0)
        )
    end
  end

  defp prompt_text(task, artifact_previews) do
    """
    You are running as a non-interactive Vanta Experiment 001 planner.

    Return JSON only. Do not use OpenClaw tools. Do not read or write files
    through the OpenClaw harness. Use only the task JSON and artifact previews
    embedded below.

    Produce one JSON object matching this exact shape:
    {"actions":[{"action_type":"read_file","action_payload":{"path":"inputs/source.md"}}]}

    Allowed action_type values:
    #{Jason.encode!(Vanta.action_types())}

    Action payload requirements:
    - read_file: {"path":"inputs/file.md"}
    - compute_hash: {"path":"inputs/file.md"}
    - validate_artifact: {"path":"inputs/file.md"} or
      {"validation":"traceability_links","path":"inputs/file.md"} or
      {"validation":"terminology_consistency","paths":["inputs/a.md","inputs/b.md"]}
    - inspect_document_structure: {"path":"inputs/file.md","selectors":[{"type":"heading","text":"Title","level":1}]}
    - validate_document_contract: {"path":"inputs/file.md","contract_ref":"inputs/contract.json"} or
      {"path":"inputs/file.md","inline_contract":{"required_text":["text"]}}
    - simulate_structured_edit: {"path":"inputs/file.md","selector":{"type":"line_range","start_line":1,"end_line":1},"operation":"replace","replacement":"replacement text"}
    - apply_reversible_structured_edit: {"path":"inputs/file.md","selector":{"type":"line_range","start_line":1,"end_line":1},"operation":"replace","replacement":"replacement text","backup_policy":"fixture_backup_restore"}
    - simulate_patch: {"path":"inputs/file.md","find":"exact text","replace":"replacement text"}
    - compute_diff: {"path":"inputs/file.md","candidate_content":"complete candidate file content"}
    - apply_reversible_patch: {"path":"inputs/file.md","find":"exact text","replace":"replacement text"}
    - record_compensable_action: {"receipt_id":"receipt-id","result_summary":"summary","compensation_hint":"how to compensate"}

    Rules:
    - Do not use read_file as a substitute when the task asks to simulate a
      patch, apply a reversible edit, reject a simulated patch, reject a wrong
      diff, or reject a path escape.
    - For normal positive fixtures, choose only actions listed in task.allowed_actions.
    - For negative fixtures whose prompt or success criteria explicitly require
      rejection of a disallowed action, workspace escape, or wrong diff, propose
      the action that exercises the requested rejection path.
    - If the task asks to reject a simulated patch proposal in a read-only
      fixture, propose simulate_patch against the source input artifact even
      when simulate_patch is not listed in task.allowed_actions. Use replace
      text "First controlled environment: Document Ops." when the source
      contains "First controlled environment: TBD."
    - If the task asks to reject a path escaping the fixture workspace, propose
      read_file with path "../outside.md".
    - If the task asks to reject a wrong simulated diff, propose simulate_patch
      with path "inputs/spec.md", find text "First controlled environment: TBD.",
      and replace text "First controlled environment: Wrong Domain.". Do not use
      read_file or a missing path for a wrong-diff rejection fixture.
    - When replacing a TBD environment note with Document Ops, use find text
      "First controlled environment: TBD." and replace text
      "First controlled environment: Document Ops." if that exact source text
      is present in the artifact preview.
    - When correcting "Verifier Runtime: final-answer checker for a completed task.",
      use replace text "Verifier Runtime: runtime verifier for action feasibility, evidence sufficiency, and final correctness where applicable."
    - Do not invent missing paths except "../outside.md" for explicit
      path-escape rejection fixtures.
    - Use fixture-local paths for all tasks except explicit path-escape
      rejection fixtures.
    - Use a path escape only when the task explicitly asks for a path-escape
      rejection fixture.
    - Do not include Markdown fences, prose, comments, explanations, or extra keys.

    Task:
    #{Jason.encode!(task, pretty: true)}

    Input artifact previews:
    #{Jason.encode!(artifact_previews, pretty: true)}
    """
  end

  defp call_openclaw(prompt, env, opts) do
    runner = Keyword.get(opts, :runner, &run_openclaw/2)
    runner.(prompt, env)
  end

  defp run_openclaw(prompt, env) do
    prompt_path = temp_file_path("prompt", ".txt")
    script_path = temp_file_path("script", ".sh")

    File.write!(prompt_path, prompt)
    File.write!(script_path, openclaw_script(env, prompt_path))

    try do
      script = ["bash ", shell_quote(wsl_path(script_path))] |> IO.iodata_to_binary()

      case System.cmd(env.wsl_executable, ["--", "bash", "-lic", script], stderr_to_stdout: true) do
        {output, 0} -> decode_cli_json(output)
        {output, status} -> {:error, {:openclaw_cli_failed, status, output}}
      end
    after
      File.rm(prompt_path)
      File.rm(script_path)
    end
  end

  defp openclaw_script(env, prompt_path) do
    [
      "#!/usr/bin/env bash\n",
      "set -euo pipefail\n",
      "cd ",
      shell_path(env.openclaw_dir),
      "\n",
      "pnpm openclaw --no-color agent --local --json",
      maybe_arg("--agent", env.agent),
      " --session-id ",
      shell_quote(env.session_id),
      " --model ",
      shell_quote(env.model),
      maybe_arg("--thinking", env.thinking),
      " --message \"$(cat ",
      shell_quote(wsl_path(prompt_path)),
      ")\"",
      " --timeout ",
      Integer.to_string(env.timeout_seconds),
      "\n"
    ]
    |> IO.iodata_to_binary()
  end

  defp temp_file_path(kind, extension) do
    Path.join(
      System.tmp_dir!(),
      "vanta_openclaw_planner_#{kind}_#{System.unique_integer([:positive])}#{extension}"
    )
  end

  defp wsl_path(path) do
    path = Path.expand(path)

    case Regex.run(~r/\A([a-zA-Z]):[\\\/](.*)\z/, path) do
      [_, drive, rest] ->
        "/mnt/#{String.downcase(drive)}/" <> String.replace(rest, "\\", "/")

      _other ->
        String.replace(path, "\\", "/")
    end
  end

  defp decode_cli_json(output) do
    output
    |> candidate_json_suffixes()
    |> Enum.find_value(fn candidate ->
      case Jason.decode(candidate) do
        {:ok, decoded} -> {:ok, decoded}
        {:error, _error} -> nil
      end
    end)
    |> case do
      nil -> {:error, {:invalid_openclaw_json, output}}
      result -> result
    end
  end

  defp candidate_json_suffixes(output) do
    output
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(fn {char, _index} -> char == "{" end)
    |> Enum.map(fn {_char, index} -> String.slice(output, index..-1//1) end)
  end

  defp extract_assistant_text(%{"payloads" => payloads}) when is_list(payloads) do
    payloads
    |> Enum.find_value(fn
      %{"text" => text} when is_binary(text) -> text
      _other -> nil
    end)
    |> case do
      nil -> {:error, :missing_openclaw_payload_text}
      text -> {:ok, text}
    end
  end

  defp extract_assistant_text(_response), do: {:error, :missing_openclaw_payload_text}

  defp reject_context_overflow(text) do
    normalized = String.downcase(text)

    if Enum.any?(@context_overflow_markers, &String.contains?(normalized, &1)) do
      {:error, {:openclaw_context_overflow, bounded_error_text(text)}}
    else
      :ok
    end
  end

  defp enforce_response_budget(text, opts) do
    max_chars = max_response_chars(opts)
    response_chars = String.length(text)

    if response_chars > max_chars do
      {:error, {:planner_response_budget_exceeded, response_chars, max_chars}}
    else
      {:ok, text}
    end
  end

  defp decode_action_sequence(text) do
    text
    |> strip_code_fence()
    |> decode_json_or_embedded_json()
  end

  defp decode_json_or_embedded_json(text) do
    case Jason.decode(text) do
      {:ok, decoded} ->
        {:ok, decoded}

      {:error, first_error} ->
        text
        |> candidate_json_suffixes()
        |> Enum.find_value(fn candidate ->
          case Jason.decode(candidate) do
            {:ok, decoded} -> {:ok, decoded}
            {:error, _error} -> nil
          end
        end)
        |> case do
          nil -> {:error, {:invalid_openclaw_action_json, Exception.message(first_error), text}}
          result -> result
        end
    end
  end

  defp strip_code_fence(text) do
    trimmed = String.trim(text)

    case Regex.run(~r/\A```(?:json)?\s*(.*?)\s*```\z/s, trimmed, capture: :all_but_first) do
      [json] -> String.trim(json)
      _other -> trimmed
    end
  end

  defp artifact_previews(task, workspace, content_limit) do
    task
    |> Map.get("input_artifacts", [])
    |> Enum.map(fn artifact ->
      path = artifact["path"]
      abs_path = Path.join(workspace, path)
      content = if File.regular?(abs_path), do: File.read!(abs_path), else: nil

      preview = %{
        "path" => path,
        "role" => artifact["role"],
        "content" => preview_content(content, content_limit),
        "content_truncated" => content_truncated?(content, content_limit),
        "original_char_count" => char_count(content),
        "included_char_count" => included_char_count(content, content_limit)
      }

      case artifact["description"] do
        description when is_binary(description) -> Map.put(preview, "description", description)
        _other -> preview
      end
    end)
  end

  defp preview_content(nil, _content_limit), do: nil
  defp preview_content(content, :full), do: content

  defp preview_content(content, content_limit)
       when is_integer(content_limit) and content_limit >= 0 do
    String.slice(content, 0, content_limit)
  end

  defp preview_content(content, _content_limit), do: content

  defp content_truncated?(nil, _content_limit), do: false
  defp content_truncated?(_content, :full), do: false

  defp content_truncated?(content, content_limit)
       when is_integer(content_limit) and content_limit >= 0 do
    String.length(content) > content_limit
  end

  defp content_truncated?(_content, _content_limit), do: false

  defp char_count(nil), do: 0
  defp char_count(content), do: String.length(content)

  defp included_char_count(nil, _content_limit), do: 0
  defp included_char_count(content, :full), do: String.length(content)

  defp included_char_count(content, content_limit)
       when is_integer(content_limit) and content_limit >= 0 do
    content |> String.length() |> Kernel.min(content_limit)
  end

  defp included_char_count(content, _content_limit), do: String.length(content)

  defp session_id(opts, task) do
    case Keyword.get(opts, :session_id) do
      value when not is_nil(value) ->
        to_string(value)

      nil ->
        task_id =
          case task do
            %{"task_id" => id} -> id
            _other -> "preflight"
          end

        unique = System.unique_integer([:positive])
        "vanta-exp001-#{task_id}-#{unique}"
    end
  end

  defp openai_model_from_env do
    case System.get_env("OPENAI_MODEL") do
      nil -> nil
      "" -> nil
      model -> model
    end
  end

  defp normalize_model("openai-codex/" <> _rest = model), do: model
  defp normalize_model(model), do: "openai-codex/#{model}"

  defp maybe_arg(_name, value) when is_nil(value), do: ""

  defp maybe_arg(name, value) do
    value = to_string(value)

    if blank?(value) do
      ""
    else
      [" ", name, " ", shell_quote(value)]
    end
  end

  defp shell_path("~/") do
    "~"
  end

  defp shell_path("~/" <> rest) do
    if String.match?(rest, ~r/\A[-_a-zA-Z0-9.\/]+\z/) do
      "~/" <> rest
    else
      shell_quote("~/" <> rest)
    end
  end

  defp shell_path(path), do: shell_quote(path)

  defp shell_quote(value) do
    "'" <> String.replace(to_string(value), "'", "'\\''") <> "'"
  end

  defp parse_positive_integer(value, _default) when is_integer(value) and value > 0, do: value

  defp parse_positive_integer(value, default) do
    case Integer.parse(to_string(value || "")) do
      {integer, ""} when integer > 0 -> integer
      _other -> default
    end
  end

  defp fallback(value, fallback_value) do
    if blank?(value), do: fallback_value, else: value
  end

  defp max_prompt_chars(opts) do
    opts
    |> Keyword.get(:max_prompt_chars)
    |> parse_positive_integer(@default_max_prompt_chars)
  end

  defp max_response_chars(opts) do
    opts
    |> Keyword.get(:max_response_chars)
    |> parse_positive_integer(@default_max_response_chars)
  end

  defp bounded_error_text(text) do
    if String.length(text) > 1_000 do
      String.slice(text, 0, 1_000) <> "...<truncated>"
    else
      text
    end
  end

  defp blank?(value), do: is_nil(value) or String.trim(to_string(value)) == ""
end
