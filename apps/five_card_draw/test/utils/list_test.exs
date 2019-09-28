defmodule FiveCardDraw.ListUtilsTest do
  use ExUnit.Case
  alias FiveCardDraw.ListUtils

  @test_data [:foo, :bar]

  defp next_index(key) do
    ListUtils.next_index(@test_data, key)
  end

  defp next_value(key) do
    ListUtils.next_value(@test_data, key)
  end

  test "next_index gets real index for non terminal element" do
    assert next_index(:foo) == 1
  end

  test "next_index gets nil for terminal element" do
    assert next_index(:bar) == nil
  end

  test "next_index gets nil for non existent element" do
    assert next_index(:baz) == nil
  end

  test "next_value gets real value for non terminal element" do
    assert next_value(:foo) == :bar
  end

  test "next_value gets nil for terminal element" do
    assert next_value(:bar) == nil
  end

  test "next_value gets nil for non existent element" do
    assert next_value(:baz) == nil
  end
end
