defmodule EchoEngineTest do
  use ExUnit.Case
  doctest EchoEngine

  test "greets the world" do
    assert EchoEngine.hello() == :world
  end
end
