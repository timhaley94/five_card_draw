defmodule FiveCardDraw.TupleUtils do
  defp inc(n), do: n + 1

  def get_index(tuple, value) when is_tuple(tuple) do
    tuple
    |> Enum.find_index(fn x -> x === value end)
  end

  def next_index(tuple, value) when is_tuple(tuple) do
    tuple
    |> get_index(value)
    |> inc()
  end

  def next_value(tuple, value) when is_tuple(tuple) do
    tuple
    |> Enum.at(next_index(tuple, value))
  end
end
