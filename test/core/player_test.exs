defmodule FiveCardDraw.PlayerTest do
  use ExUnit.Case
  alias FiveCardDraw.Player
  alias FiveCardDraw.Hand
  alias FiveCardDraw.Purse
  import ShorterMaps

  defp assert_equal(x, y) do
    assert x == y
  end

  test "creates unique id" do
    assert Player.new().id != Player.new().id
  end

  test "initializes with no bet" do
    Player.new()
    |> Player.current_bet()
    |> assert_equal(0)
  end

  test "anted? before ante" do
    Player.new()
    |> Player.anted?()
    |> assert_equal(false)
  end

  test "ante sets anted?" do
    Player.new()
    |> Player.ante()
    |> Player.anted?()
    |> assert_equal(true)
  end

  test "ante updates current bet" do
    Player.new()
    |> Player.ante()
    |> Player.current_bet()
    |> assert_equal(5)
  end

  test "second ante doesn't update anted?" do
    Player.new()
    |> Player.ante()
    |> Player.ante()
    |> Player.anted?()
    |> assert_equal(true)
  end

  test "second ante doesn't update current bet" do
    Player.new()
    |> Player.ante()
    |> Player.ante()
    |> Player.current_bet()
    |> assert_equal(5)
  end

  test "initializes with no hand" do
    Player.new()
    |> Player.hand()
    |> assert_equal(nil)
  end

  test "deal" do
    h = Player.new()
    |> Player.deal()
    |> Player.hand()

    assert %Hand{} = h
  end

  test "deal with hand alreay" do
    p = Player.new() |> Player.deal()
    h1 = p |> Player.hand()
    h2 = p
    |> Player.deal()
    |> Player.hand()

    assert h1.id == h2.id
  end

  defp test_drew?(player = %Player{}, expected) do
    h = player |> Player.hand()

    id =
      if h != nil do
        h
        |> Map.get(:cards)
        |> List.first()
        |> Map.get(:id)
      else
        1
      end

    player
    |> Player.draw([id])
    |> Player.drew?()
    |> assert_equal(expected)
  end

  test "draw without hand" do
    Player.new()
    |> test_drew?(false)
  end

  test "draw with hand" do
    Player.new()
    |> Player.deal()
    |> test_drew?(true)
  end

  test "bet before ante" do
    Player.new()
    |> Player.bet(25)
    |> Player.current_bet()
    |> assert_equal(0)
  end

  test "normal bet" do
    Player.new()
    |> Player.ante()
    |> Player.bet(25)
    |> Player.current_bet()
    |> assert_equal(25)
  end

  test "normal bet does not set all_in?" do
    Player.new()
    |> Player.ante()
    |> Player.bet(25)
    |> Player.all_in?()
    |> assert_equal(false)
  end

  test "all in bet" do
    Player.new()
    |> Player.ante()
    |> Player.bet(1200)
    |> Player.current_bet()
    |> assert_equal(1000)
  end

  test "all in bet sets all_in?" do
    Player.new()
    |> Player.ante()
    |> Player.bet(1200)
    |> Player.all_in?()
    |> assert_equal(true)
  end

  test "second all in bet" do
    Player.new()
    |> Player.ante()
    |> Player.bet(1200)
    |> Player.bet(2000)
    |> Player.current_bet()
    |> assert_equal(1000)
  end

  test "second all in bet does not set all_in?" do
    Player.new()
    |> Player.ante()
    |> Player.bet(1200)
    |> Player.bet(2000)
    |> Player.all_in?()
    |> assert_equal(true)
  end

  test "resolve no winnings resets current_bet" do
    Player.new()
    |> Player.ante()
    |> Player.bet(25)
    |> Player.resolve_round(0)
    |> Player.current_bet()
    |> assert_equal(0)
  end

  defp test_resolve(~M{bet, winnings, expected}) do
    Player.new()
    |> Player.ante()
    |> Player.bet(bet)
    |> Player.resolve_round(winnings)
    |> Player.bankroll()
    |> assert_equal(expected)
  end

  test "resolve no winnings" do
    test_resolve(%{
      bet: 25,
      winnings: 0,
      expected: 975
    })
  end

  test "resolve winnings less than bet" do
    test_resolve(%{
      bet: 25,
      winnings: 10,
      expected: 985
    })
  end

  test "resolve winnings more than bet" do
    test_resolve(%{
      bet: 25,
      winnings: 35,
      expected: 1010
    })
  end

  test "resolve all in loss" do
    test_resolve(%{
      bet: 1000,
      winnings: 0,
      expected: 0
    })
  end

  test "resolve all in win" do
    test_resolve(%{
      bet: 1000,
      winnings: 2000,
      expected: 2000
    })
  end

  test "resolve fields reset" do
    p1 = Player.new()

    p2 = p1
    |> Player.ante()
    |> Player.bet(25)
    |> Player.resolve_round(0)

    assert p1.id == p2.id
    assert Player.anted?(p2) == false
    assert Player.hand(p2) == nil
    assert %Purse{} = p2.purse
  end
end
