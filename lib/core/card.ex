defmodule FiveCardDraw.Card do
  alias __MODULE__
  import UUID

  @suits [:hearts, :diamonds, :clubs, :spades]
  @ranks [
    :two,
    :three,
    :four,
    :five,
    :six,
    :seven,
    :eight,
    :nine,
    :ten,
    :jack,
    :queen,
    :king,
    :ace
  ]

  @enforce_keys [:id, :suit, :rank]
  defstruct(
    id: nil,
    suit: :hearts,
    rank: :ace
  )

  defp generate_id, do: uuid1()

  def rank_int(%Card{ rank: rank }) do
    @ranks
    |> Enum.find_index(fn(x) -> x == rank end)
  end

  def new do
    %Card{
      id: generate_id(),
      suit: Enum.random(@suits),
      rank: Enum.random(@ranks)
    }
  end
end
