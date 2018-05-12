defmodule FiveCardDraw do
  @moduledoc """
  Documentation for FiveCardDraw.
  """

  @doc """
  Hello world.

  ## Examples

      iex> FiveCardDraw.hello
      :world

  """
  def init(default_opts) do
    IO.puts "starting up Helloplug..."
    default_opts
  end

  def call(conn, _opts) do
    IO.puts "saying hello!"
    Plug.Conn.send_resp(conn, 200, "Hello, world!")
  end
end
