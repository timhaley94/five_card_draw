defmodule FiveCardDraw do
  alias FiveCardDraw.UserServer
  alias FiveCardDraw.GameServer
  alias FiveCardDraw.GameSupervisor
  import ShorterMaps

  def create_game() do
    {:ok, id} = GameSupervisor.create_game()
    {:ok, game} = GameServer.get_state(id)

    {:ok, %{id: id, game: game}}
  end

  def add_user(~M{game_id}) do
    {:ok, user} = UserServer.add_user()
    {:ok, game} = GameServer.add_user(game_id)

    {:ok, %{user: user, game: game}}
  end

  def move(~M{game_id, user_id, token, data}) do
    {:ok} = UserServer.auth_user(user_id, token)
    {:ok, game} = GameServer.move(game_id, user_id, data)

    {:ok, %{game: game}}
  end
end
