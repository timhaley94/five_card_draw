defmodule FiveCardDraw.ListUtils do
  defp nil_safe_at(_list, nil), do: nil
  defp nil_safe_at(list, n), do: Enum.at(list, n)

  defp capped_inc(nil, _length), do: nil
  defp capped_inc(n, length) when n + 1 < length, do: n + 1
  defp capped_inc(_n, _length), do: nil

  def next_index(list, value) do
    list
    |> Enum.find_index(fn x -> x == value end)
    |> capped_inc(length(list))
  end

  def next_value(list, value) do
    list
    |> nil_safe_at(next_index(list, value))
  end
end
