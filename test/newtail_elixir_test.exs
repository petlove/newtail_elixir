defmodule NewtailElixirTest do
  use ExUnit.Case
  doctest NewtailElixir

  test "greets the world" do
    assert NewtailElixir.hello() == :world
  end
end
