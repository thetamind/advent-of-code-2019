defmodule ComputerTest do
  use ExUnit.Case
  doctest Computer

  test "part 1 solution" do
    input = File.read!("data/input.txt")
    assert Computer.part1(input) == 4_462_686
  end

  test "load" do
    assert Computer.load("2,0,0,0,99\n") == [2, 0, 0, 0, 99]
  end
end
