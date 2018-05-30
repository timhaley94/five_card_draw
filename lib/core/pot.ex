defmodule FiveCardDraw.Pot do
  alias __MODULE__
  alias FiveCardDraw.Purse
  import FiveCardDraw.ListUtils
  import ShorterMaps

  @enforce_keys [:players, :active_ids]
  defstruct(
    finished?: false,
    active_ids: nil,
    current_id: nil,
    number_of_rounds: 2,
    current_round: 0,
    players: nil
  )

  defp get_player(pot = ~M{%Pot current_id}), do: get_player(pot, current_id)
  defp get_player(_pot = ~M{%Pot players}, player_id) do
    players
    |> Map.fetch!(player_id)
  end

  defp all_in?(_pot = ~M{%Pot players}) do
    players
    |> get_player()
    |> all_in?()
  end

  defp all_in?(_player = ~M{purse}), do: Purse.all_in?(purse)

  defp current_bet(_pot = ~M{%Pot players}) do
    players
    |> get_player()
    |> current_bet()
  end

  defp current_bet(_player = %{ purse: ~M{%Purse current_bet} }), do: current_bet

  defp available_money(_pot = ~M{%Pot players}) do
    players
    |> get_player()
    |> available_money()
  end

  defp available_money(_player = %{ purse: ~M{%Purse available_money} }), do: available_money

  defp lead_bet(~M{%Pot players}) do
    players
    |> Enum.max_by(&current_bet/1)
  end

  defp call_only?(~M{%Pot current_round, number_of_rounds}) do
    current_round + 1 == number_of_rounds
  end

  defp valid_bet?(pot = %Pot{}, ~M{bet}) do
    valid_bet?(%{
      call_only?: call_only?(pot),
      min_bet: min(lead_bet(pot), available_money(pot)),
      new_bet: current_bet(pot) + bet
    })
  end

  defp valid_bet?(~M{call_only?: true, min_bet, new_bet}), do: min_bet == new_bet
  defp valid_bet?(~M{call_only?: false, min_bet, new_bet}), do: min_bet >= new_bet

  defp handle_all_in(pot = %Pot{}, player_id) do
    if all_in?(get_player(pot, player_id)) do
      pot
      |> deactivate_player(player_id)
    else
      pot
    end
  end

  def bet(pot = ~M{%Pot current_id}, data = ~M{bet}) do
    if valid_bet?(pot, data) do
      pot
      |> update_in([:players, current_id, :purse], fn purse -> Purse.bet(purse, bet) end)
      |> update_meta_data()
      |> handle_all_in(current_id)
    else
      pot
    end
  end

  def move(pot = ~M{%Pot finished?, current_id}, data = ~M{action, player_id})
      when not finished? and player_id == current_id do
    case action do
      :bet -> bet(pot, data)
      :fold -> fold(pot)
      _ -> pot
    end
  end

  def move(pot, _data), do: pot

  defp fold(pot = ~M{%Pot current_id}) do
    pot
    |> update_meta_data()
    |> deactivate_player(current_id)
  end

  defp deactivate_player(pot = ~M{%Pot active_ids}, player_id) do
    pot
    |> Map.put(:active_ids, Enum.reject(active_ids, fn id -> id == player_id end))
  end

  defp advance_current_round(pot = ~M{%Pot current_round, number_of_rounds}) do
    pot
    |> Map.put(:current_round, current_round + 1)
    |> Map.put(:finished?, current_round + 1 == number_of_rounds)
  end

  defp advance_current_id(pot = ~M{%Pot active_ids}, nil) do
    pot
    |> advance_current_round()
    |> advance_current_id(List.first(active_ids))
  end

  defp advance_current_id(pot = %Pot{}, next_id) do
    pot
    |> Map.put(:current_id, next_id)
  end

  defp advance_current_id(pot = ~M{%Pot active_ids, current_id}) do
    pot
    |> advance_current_id(next_value(active_ids, current_id))
  end

  defp all_players_all_in?(~M{%Pot players}) do
    players
    |> Enum.all?(&all_in?/1)
  end

  defp set_finished(pot = ~M{%Pot finished?: true}), do: pot
  defp set_finished(pot = %Pot{}) do
    pot
    |> Map.put(:finished?, all_players_all_in?(pot))
  end

  defp update_meta_data(pot = %Pot{}) do
    pot
    |> advance_current_id()
    |> set_finished()
  end

  defp init_active_ids(players) do
    players
    |> Enum.map(fn player -> player.id end)
  end

  defp init_player(~M{id, available_money}) do
    %{
      id: id,
      purse: Purse.new(available_money)
    }
  end

  defp init_players(players) do
    players
    |> Enum.map(&init_player/1)
    |> Enum.map(fn player -> {player.id, player} end)
    |> Map.new()
  end

  defp init_current_id(pot = ~M{%Pot active_ids}) do
    pot
    |> Map.put(:current_id, List.first(active_ids))
  end

  def new(players) do
    %Pot{
      active_ids: init_active_ids(players),
      players: init_players(players)
    }
    |> init_current_id()
  end

  # HEYEYYEYEYEY
  # You don't need side pots. The logic is simple for awarding winnings.
  # Once a player is all in at value x, they (upon winning) are awarded
  # min(x, y) where y is the bet of every other player.
end
