defmodule ComputerTest do
  use ExUnit.Case
  doctest Computer

  test "part 1 problem" do
    input = File.read!("data/input.txt")
    assert Computer.part1(input) == -111
  end
end
