defmodule FiveCardDraw.CompareListsUtils do
  def min_length(lists) do
    lists
    |> Enum.min_by(&length/1)
    |> length()
  end

  def max_by(lists, max_fn) do
    max_by(%{
      mapped_lists: Enum.map(lists, fn list -> %{ original: list, mapped: max_fn.(list) } end),
      max_lists: nil
    })
  end

  def max_by(context = %{ mapped_lists: lists, max_lists: nil }) do
    context
    |> Map.put(:max_lists, max(Enum.map(lists, fn list -> list.mapped end)))
    |> max_by()
  end

  def max_by(%{ mapped_lists: lists, max_lists: maxs }) do
    lists
    |> Enum.filter(fn list -> Enum.member?(maxs, list.mapped) end)
    |> Enum.map(fn list -> list.original end)
  end

  def max(lists) do
    lists
    |> max(0, min_length(lists))
  end

  def max(lists = [_list], _n, _length), do: lists
  def max(lists, n, length) when n == length, do: lists

  def max(lists, n, length) do
    lists
    |> Enum.group_by(fn list -> Enum.fetch!(list, n) end)
    |> Enum.max_by(fn ({value, _new_lists}) -> value end)
    |> elem(1)
    |> max(n + 1, length)
  end
end
