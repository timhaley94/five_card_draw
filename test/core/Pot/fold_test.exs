defmodule FiveCardDraw.PotFoldTest do
  defp test_data() do
    %{
      pot: %Pot{
        finished?: false,
        active_ids: [1, 2, 3],
        current_id: 1,
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
    }
  end

  setup do
    {:ok, test_data()}
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
end
