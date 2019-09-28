defmodule FiveCardDraw.CardTest do
  use ExUnit.Case
  alias FiveCardDraw.Card

  defp rank_int(rank) do
    %Card{ id: "1", rank: rank, suit: :hearts }
    |> Card.rank_int()
  end

  test "rank_int returns higher value for queen than three" do
    assert rank_int(:three) < rank_int(:queen)
  end

  test "rank_int returns higher value for ace than queen" do
    assert rank_int(:queen) < rank_int(:ace)
  end

  test "new generates id" do
    assert Card.new().id != nil
  end
end
