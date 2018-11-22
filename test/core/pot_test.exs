defmodule FiveCardDraw.PurseTest do
  use ExUnit.Case
  alias FiveCardDraw.Pot

  defp assert_equal(x, y) do
    assert x == y
  end

  defp assert_match(value, pattern) do
    assert match(pattern, value)
  end

  defp test_new(input, expected) do
    input
    |> Pot.new()
    |> assert_equal(expected)
  end

  test "new can handle list of only ids" do
    test_new(
      [%{ id: 1 }, %{ id: 2 }, %{ id: 3 }],

    )
  end

  test "new can handle list with available_money options" do

  end

  defp new_pot(~M{finished?, is_turn?, player_id}) do
    %Pot{
      finished?: finished?,
      active_ids: [1, 2, 3],
      current_id: current_id(is_turn?, player_id),
      current_round: 1,
      number_of_rounds: 2,
      players: %{
        1 => %{
          purse: %Purse{
            current_bet: 0,
            available_money: 500
          }
        },
        2 => %{
          purse: %Purse{
            current_bet: 0,
            available_money: 1000
          }
        },
        3 => %{
          purse: %Purse{
            current_bet: 0,
            available_money: 1000
          }
        }
      }
    }
  end

  defp new_pot(data = %{}) do
    data
    |> Map.put(:player_id, 1)
    |> new_pot()
  end

  defp next_id(id), do rem(player_id, 3) + 1

  defp current_id(_is_turn? = true, player_id), do: player_id
  defp current_id(_is_turn? = false, player_id), do: next_id(player_id)

  defp fold(data = ~M{player_id}) do
    data
    |> new_pot()
    |> Pot.move(%{ action: :fold, player_id: player_id })
  end

  # defp assert_fail(pot = ~M{%Pot current_id}, player_id) do
  #   assert current_id == player_id
  # end
  #
  # defp assert_success(pot = ~M{%Pot current_id}, player_id) do
  #   assert current_id == next_id(player_id)
  # end
  #
  # defp assert_(~M{%Pot current_id}, data = ~M{player_id}) do
  #   data
  #   |> new_pot()
  #   |> assert_fail(player_id)
  # end
  #
  # defp test_fold_success(data = ~M{player_id}) do
  #   data
  #   |> new_pot()
  #   |> assert_success(player_id)
  # end

  defp assert_advanced_current_id(~M{%Pot current_id}, player_id) do
    assert current_id == next_id(player_id)
  end

  defp assert_id_removed(~M{%Pot actives_id}, player_id) do
    assert not player_id in active_ids
  end

  test "fold can't happen when pot is finished" do
    %{
      finished?: true,
      is_turn?: true
    }
    |> fold()
    |> assert_fail()
  end

  test "fold can't happen when it isn't the player's turn" do
    %{
      finished?: false,
      is_turn?: false
    }
    |> fold()
    |> assert_fail()
  end

  test "fold can happen when the pot isn't finished and it is the player's turn" do
    %{
      finished?: false,
      is_turn?: true
    }
  end

  test "fold removes player's id from active ids" do

  end

  test "fold advances the current_id pointer"
  test "fold can advance the current_round counter"
  test "fold can set the game to finished by leaving only one active player"
  test "fold can set the game to finished if last player in final round"

  test "bet can't happen when pot is finished"
  test "bet can't happen when it isn't the player's turn"
  test "bet can happen when pot is finished and it is the player's turn"
  test "bet advances the current_id pointer"
  test "bet can advance the current_round counter"
  test "bet can set the game to finished if last player in final round"
  test "bet cannot bet more than all in"
  test "bet can go all in"
  test "bet can go higher than lead bet"
  test "bet cannot go lower than lead bet"
  test "bet can be exactly lead bet"
  test "in final round, bet can go all in"
  test "in final round, bet cannot go higher than lead bet"
  test "in final round, bet can be exactly lead bet"
end
