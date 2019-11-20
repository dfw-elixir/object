defmodule ObjectTest do
  use ExUnit.Case
  doctest Object

  test "greets the world" do
    assert Object.hello() == :world
  end
end
