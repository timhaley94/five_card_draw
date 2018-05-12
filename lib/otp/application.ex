defmodule FiveCardDraw.Application do
  use Application

  defp router_opts do
    [scheme: :http,
     plug: FiveCardDraw,
     options: [port: 4001]]
  end

  defp router do
    Plug.Adapters.Cowboy.child_spec(router_opts())
  end

  defp children do
    [router()]
  end

  defp supervisor_opts do
    [strategy: :one_for_one,
     name: FiveCardDraw.Supervisor]
  end

  def start(_type, _args) do
    Supervisor.start_link(children(), supervisor_opts())
  end
end
