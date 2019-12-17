defmodule Computer.Day05Test do
  use ExUnit.Case, async: true
  doctest Computer.Day05

  test "part 1 solution" do
    input = File.read!("data/input.txt")
    assert Computer.Day05.part1(input) == 4_462_686
  end
end
