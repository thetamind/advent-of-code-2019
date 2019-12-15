defmodule ComputerTest do
  use ExUnit.Case, async: true
  doctest Computer

  test "load" do
    assert Computer.load("2,0,0,0,99\n") == [2, 0, 0, 0, 99]
  end
end
