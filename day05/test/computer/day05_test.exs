defmodule Computer.Day05Test do
  use ExUnit.Case, async: true
  doctest Computer.Day05

  test "part 1 solution" do
    input = File.read!("data/day05.txt")
    assert Computer.Day05.part1(input) == 6_745_903
  end
end
