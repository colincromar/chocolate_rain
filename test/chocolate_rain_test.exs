defmodule ChocolateRainTest do
  use ExUnit.Case
  doctest ChocolateRain

  test "greets the world" do
    assert ChocolateRain.hello() == :world
  end
end
