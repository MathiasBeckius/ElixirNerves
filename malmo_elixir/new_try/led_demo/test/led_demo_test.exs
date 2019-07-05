defmodule LedDemoTest do
  use ExUnit.Case
  doctest LedDemo

  test "greets the world" do
    assert LedDemo.hello() == :world
  end
end
