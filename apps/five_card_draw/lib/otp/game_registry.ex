defmodule FiveCardDraw.GameRegistry do
  def via_tuple(id) do
    {:via, Registry, {__MODULE__, id}}
  end

  def spec() do
    {Registry, keys: :unique, name: __MODULE__}
  end
end
