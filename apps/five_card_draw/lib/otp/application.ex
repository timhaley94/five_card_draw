defmodule FiveCardDraw.Application do
  use Application

  defp children do
    []
  end

  defp supervisor_opts do
    [strategy: :one_for_one,
     name: FiveCardDraw.Supervisor]
  end

  def start(_type, _args) do
    Supervisor.start_link(children(), supervisor_opts())
  end
end
