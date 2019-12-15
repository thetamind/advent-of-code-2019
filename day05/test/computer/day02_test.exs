defmodule Computer.Day02Test do
  @moduledoc false

  use ExUnit.Case, async: true

  test "part 1 solution" do
    input = File.read!("data/input.txt")
    assert Computer.Day02.part1(input) == 4_462_686
  end

  @tag :slow
  test "part 2 solution" do
    input = File.read!("data/input.txt")
    assert Computer.Day02.part2(input) == 5936
  end
end
