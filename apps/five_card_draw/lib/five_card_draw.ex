defmodule FiveCardDraw do
  alias FiveCardDraw.UserServer
  alias FiveCardDraw.GameRegistry
  alias FiveCardDraw.GameServer
  alias FiveCardDraw.GameSupervisor
  import ShorterMaps

  def create_game() do
    {:ok, pid} = GameSupervisor.create_game()
    {:ok, id} = GameRegistry.register_pid(pid)
    {:ok, game} = GameServer.get_state(pid)

    {:ok, %{id: id, game: game}}
  end

  def add_user(~M{game_id}) do
    {:ok, user} = UserServer.add_user()
    {:ok, pid} = GameRegistry.get_pid(game_id)
    {:ok, game} = GameServer.add_user(pid)

    {:ok, %{user: user, game: game}}
  end

  def move(~M{game_id, user_id, token, data}) do
    {:ok} = UserServer.auth_user(user_id, token)
    {:ok, pid} = GameRegistry.get_pid(game_id)
    {:ok, game} = GameServer.move(pid, user_id, data)

    {:ok, %{game: game}}
  end
end
