defmodule FiveCardDraw.CompareListsUtilsTest do
  use ExUnit.Case
  alias FiveCardDraw.CompareListsUtils

  @length_test_list [[3, [4]], [1, :foo]]

  defp min_length(list) do
    CompareListsUtils.min_length([ list | @length_test_list ])
  end

  test "min_length works for lists of same length" do
    assert min_length([1, nil]) == 2
  end

  test "min_length works for lists of different lengths" do
    assert min_length([1]) == 1
  end

  test "min_length works when one list is empty" do
    assert min_length([]) == 0
  end

  @max_test_list [[2, 1], [1, 5]]

  defp max(list) do
    CompareListsUtils.max([ list | @max_test_list ])
  end

  test "max only considers first element if max is found" do
    assert max([1, 4]) == [[2, 1]]
  end

  test "max considers next element if first element is shared" do
    assert max([2, 4]) == [[2, 4]]
  end

  test "max recongizes ties" do
    assert max([2, 1]) == [[2, 1], [2, 1]]
  end

  test "max handles lists of different lengths" do
    assert max([2]) == [[2], [2, 1]]
  end

  test "max handles when one of the lists is empty" do
    assert max([]) == [[] | @max_test_list]
  end

  defp zero_if_even(n) when rem(n, 2) == 0, do: 0
  defp zero_if_even(n), do: n

  defp zero_if_even_list(list) do
    list
    |> Enum.map(&zero_if_even/1)
  end

  @max_by_test_list [[5, 3], [6, 5]]

  defp max_by(list) do
    [ list | @max_by_test_list ]
    |> CompareListsUtils.max_by(&zero_if_even_list/1)
  end

  test "max_by actaully maps" do
    assert max_by([6, 3]) == [[5, 3]]
  end

  test "max_by only considers first element if max is found" do
    assert max_by([7, 3]) == [[7, 3]]
  end

  test "max_by considers next element if first element is shared" do
    assert max_by([5, 1]) == [[5, 3]]
  end

  test "max_by recongizes ties" do
    assert max_by([5, 3]) == [[5, 3], [5, 3]]
  end

  test "max_by handles lists of different lengths" do
    assert max_by([5]) == [[5], [5, 3]]
  end

  test "max_by handles when one of the lists is empty" do
    assert max_by([]) == [[] | @max_by_test_list ]
  end
end
