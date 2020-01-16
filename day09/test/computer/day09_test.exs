defmodule Computer.Day09Test do
  use ExUnit.Case, async: true

  doctest Computer.Day09

  test "part 1 solution" do
    input = File.read!("data/day09.txt")
    assert Computer.Day09.part1(input) == [-1]
  end
end
