defmodule FiveCardDraw.PurseTest do
  use ExUnit.Case
  alias FiveCardDraw.Purse
  import ShorterMaps

  defp assert_equal(x, y) do
    assert x == y
  end

  defp test_new(opts, expected) do
    Purse.new(opts)
    |> Map.fetch!(:available_money)
    |> assert_equal(expected)
  end

  test "new can handle available_money option" do
    test_new(%{ available_money: 500 }, 500)
  end

  test "new can hanlde no available_money option" do
    test_new(%{}, Purse.starting_cash())
  end

  defp test_getter(purse, getter, expected) do
    purse
    |> getter.()
    |> assert_equal(expected)
  end

  defp test_all_in(current, available, expected) do
    %Purse{
      current_bet: current,
      available_money: available
    }
    |> test_getter(&Purse.all_in?/1, expected)
  end

  test "all_in? can handle when current_bet is lower than available_money" do
    test_all_in(500, 1000, false)
  end

  test "all_in? can handle when current_bet is equal to available_money" do
    test_all_in(1000, 1000, true)
  end

  test "all_in? can handle when current_bet is greater than available_money" do
    test_all_in(1500, 1000, true)
  end

  defp test_broke(available, expected) do
    %Purse{
      available_money: available
    }
    |> test_getter(&Purse.broke?/1, expected)
  end

  test "broke? can handle when available_money is greater than zero" do
    test_broke(500, false)
  end

  test "broke? can handle when available_money is equal to zero" do
    test_broke(0, true)
  end

  test "broke? can handle when available_money is less than zero" do
    test_broke(-500, true)
  end

  defp call_bet(~M{starting_bet, next_bet, available}) do
    %Purse{
      current_bet: starting_bet,
      available_money: available
    }
    |> Purse.bet(next_bet)
  end

  defp test_bet(opts = ~M{expected}) do
    opts
    |> call_bet()
    |> Map.fetch!(:current_bet)
    |> assert_equal(expected)
  end

  defp test_bet_error(opts) do
    assert_raise(FunctionClauseError, fn ->
      call_bet(opts)
    end)
  end

  test "bet can handle an initial bet" do
    test_bet(%{
      starting_bet: 0,
      next_bet: 500,
      available: 1000,
      expected: 500
    })
  end

  test "bet can handle a second bet" do
    test_bet(%{
      starting_bet: 250,
      next_bet: 500,
      available: 1000,
      expected: 500
    })
  end

  test "bet can handle an all in bet" do
    test_bet(%{
      starting_bet: 500,
      next_bet: 1000,
      available: 750,
      expected: 750
    })
  end

  test "bet can handle bet after all in" do
    test_bet(%{
      starting_bet: 1000,
      next_bet: 1200,
      available: 1000,
      expected: 1000
    })
  end

  test "bet errors on greater than all in bet" do
    test_bet_error(%{
      starting_bet: 500,
      next_bet: 250,
      available: 1000,
    })
  end

  defp test_resolve_bet(~M{current, available, winnings, expected}) do
    %Purse{
      current_bet: current,
      available_money: available
    }
    |> Purse.resolve_bet(winnings)
    |> Map.fetch!(:available_money)
    |> assert_equal(expected)
  end

  test "resolve_bet can handle zero winnings" do
    test_resolve_bet(%{
      current: 250,
      available: 1000,
      winnings: 0,
      expected: 750
    })
  end

  test "resolve_bet can handle winnings less than current_bet" do
    test_resolve_bet(%{
      current: 250,
      available: 1000,
      winnings: 100,
      expected: 850
    })
  end

  test "resolve_bet can handle winnings greater than current_bet" do
    test_resolve_bet(%{
      current: 250,
      available: 1000,
      winnings: 350,
      expected: 1100
    })
  end

  test "resolve_bet can handle zero winnings on all in bet" do
    test_resolve_bet(%{
      current: 1000,
      available: 1000,
      winnings: 0,
      expected: 0
    })
  end
end
