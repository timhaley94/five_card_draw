defmodule FiveCardDraw.RoundTest do
  use ExUnit.Case
  alias FiveCardDraw.Round
  alias FiveCardDraw.Player
  import UUID

  defp assert_equal(a, b) do
    assert a == b
  end

  defp assert_does_include(l, val) do
    assert val in l
  end

  defp assert_does_not_include(l, val) do
    assert not val in l
  end

  defp ante_test_data() do
    Round.new([
      Player.new(uuid1()),
      Player.new(uuid1()),
      Player.new(uuid1())
    ])
  end

  defp get_id(round = %Round{}, position) do
    round
    |> Round.active_ids()
    |> Enum.fetch!(position)
  end

  defp ante(round = %Round{}, id) do
    round
    |> Round.move(%{player_id: id})
  end

  defp fold(round = %Round{}, id) do
    round
    |> Round.move(%{player_id: id, action: :fold})
  end

  defp test_not_waiting(round = %Round{}, id) do
    round
    |> Round.awaiting_ids()
    |> assert_does_not_include(id)

    round
    |> Round.active_ids()
    |> assert_does_include(id)

    round
  end

  defp test_folded(round = %Round{}, id) do
    round
    |> Round.awaiting_ids()
    |> assert_does_not_include(id)

    round
    |> Round.active_ids()
    |> assert_does_not_include(id)

    round
  end

  defp test_stage(round = %Round{}, stage) do
    assert round.stage == stage
  end

  test "test ante" do
    round = ante_test_data()
    id = get_id(round, 0)

    round
    |> ante(id)
    |> test_not_waiting(id)
  end

  test "test second ante" do
    round = ante_test_data()
    id1 = get_id(round, 0)
    id2 = get_id(round, 1)

    round
    |> ante(id1)
    |> ante(id2)
    |> test_not_waiting(id1)
    |> test_not_waiting(id2)
  end

  test "fold on ante" do
    round = ante_test_data()
    id = get_id(round, 0)

    round
    |> fold(id)
    |> test_folded(id)
  end

  test "out of order ante" do
    round = ante_test_data()
    id1 = get_id(round, 0)
    id2 = get_id(round, 2)

    round
    |> ante(id1)
    |> ante(id2)
    |> test_not_waiting(id1)
    |> test_not_waiting(id2)
  end

  test "out of order fold on ante" do
    round = ante_test_data()
    id = get_id(round, 2)

    round
    |> fold(id)
    |> test_folded(id)
  end

  test "final ante" do
    round = ante_test_data()

    round
    |> ante(get_id(round, 0))
    |> fold(get_id(round, 2))
    |> ante(get_id(round, 1))
    |> test_stage(:bet_1)
  end

  defp bet_test_data() do
    round = ante_test_data()

    round
    |> ante(get_id(round, 0))
    |> ante(get_id(round, 1))
    |> ante(get_id(round, 2))
  end

  defp bet(round = %Round{}, id, bet) do
    round
    |> Round.move(%{player_id: id, action: :raise, amount: bet})
  end

  defp call(round = %Round{}, id) do
    round
    |> Round.move(%{player_id: id, action: :call})
  end

  defp test_player_bet(round = %Round{}, id, amount) do
    round
    |> Map.fetch!(:players)
    |> Map.fetch!(id)
    |> Player.current_bet()
    |> assert_equal(amount)

    round
  end

  test "check" do
    round = bet_test_data()
    id = get_id(round, 0)

    round
    |> call(id)
    |> test_not_waiting(id)
  end

  test "raise" do
    round = bet_test_data()
    id = get_id(round, 0)

    round
    |> bet(id, 15)
    |> test_not_waiting(id)
    |> test_player_bet(id, 20)
  end

  test "call" do
    round = bet_test_data()
    id1 = get_id(round, 0)
    id2 = get_id(round, 1)

    round
    |> bet(id1, 15)
    |> call(id2)
    |> test_not_waiting(id1)
    |> test_not_waiting(id2)
    |> test_player_bet(id1, 20)
    |> test_player_bet(id2, 20)
  end

  test "out of turn" do
    round = bet_test_data()
    id = get_id(round, 1)

    round
    |> bet(id, 15)
    |> test_not_waiting(id)
    |> test_player_bet(id, 5)
  end

  test "all check" do
    round = bet_test_data()
    id1 = get_id(round, 0)
    id2 = get_id(round, 1)
    id3 = get_id(round, 2)

    round
    |> call(id1)
    |> call(id2)
    |> call(id3)
    |> test_player_bet(id1, 5)
    |> test_player_bet(id2, 5)
    |> test_player_bet(id3, 5)
    |> test_stage(:draw)
  end

  test "fold" do
    round = bet_test_data()
    id = get_id(round, 0)

    round
    |> fold(id)
    |> test_folded(id)
    |> test_player_bet(id, 5)
  end

  test "fold on call" do
    round = bet_test_data()
    id1 = get_id(round, 0)
    id2 = get_id(round, 1)

    round
    |> bet(id1, 15)
    |> fold(id2)
    |> test_folded(id2)
    |> test_player_bet(id2, 5)
  end

  test "all call" do
    round = bet_test_data()
    id1 = get_id(round, 0)
    id2 = get_id(round, 1)
    id3 = get_id(round, 2)

    round
    |> bet(id1, 15)
    |> call(id2)
    |> call(id3)
    |> test_player_bet(id1, 20)
    |> test_player_bet(id2, 20)
    |> test_player_bet(id3, 20)
    |> test_stage(:draw)
  end

  test "final raise" do
    round = bet_test_data()
    id1 = get_id(round, 0)
    id2 = get_id(round, 1)
    id3 = get_id(round, 2)

    round
    |> bet(id1, 15)
    |> call(id2)
    |> bet(id3, 15)
    |> test_player_bet(id1, 20)
    |> test_player_bet(id2, 20)
    |> test_player_bet(id3, 35)
    |> test_stage(:call_1)
  end
end
