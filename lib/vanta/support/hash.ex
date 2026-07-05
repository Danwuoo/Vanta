defmodule Vanta.Hash do
  @moduledoc false

  def sha256(data) when is_binary(data) do
    "sha256:" <> Base.encode16(:crypto.hash(:sha256, data), case: :lower)
  end

  def file_hash(path) do
    path
    |> File.read!()
    |> sha256()
  end

  def term_hash(term) do
    term
    |> canonical_term()
    |> :erlang.term_to_binary()
    |> sha256()
  end

  def state_hash(state) when is_map(state) do
    state
    |> Map.delete("state_hash")
    |> term_hash()
  end

  defp canonical_term(map) when is_map(map) do
    map
    |> Enum.map(fn {key, value} -> {to_string(key), canonical_term(value)} end)
    |> Enum.sort_by(fn {key, _value} -> key end)
  end

  defp canonical_term(list) when is_list(list), do: Enum.map(list, &canonical_term/1)
  defp canonical_term(value), do: value
end
