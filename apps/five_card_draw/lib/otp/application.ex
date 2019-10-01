defmodule FiveCardDraw.Application do
  use Application
  alias FiveCardDraw.UserServer
  alias FiveCardDraw.GameRegistry
  alias FiveCardDraw.GameSupervisor

  defp children do
    [
      GameRegistry.spec(),
      UserServer,
      GameSupervisor,
    ]
  end

  defp supervisor_opts do
    [strategy: :rest_for_one,
     name: FiveCardDraw.Supervisor]
  end

  def start(_type, _args) do
    Supervisor.start_link(children(), supervisor_opts())
  end
end
