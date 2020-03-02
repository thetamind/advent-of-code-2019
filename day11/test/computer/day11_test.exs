defmodule Computer.Day11Test do
  use ExUnit.Case, async: true

  alias Computer.Day11

  test "part 1 solution" do
    input = File.read!("data/day11.txt")
    assert Day11.part1(input) == -1
  end

  describe "example" do
    test "step 1" do
      expected =
        ~S"""
        .....
        .....
        .<#..
        .....
        .....
        """
        |> String.trim_trailing("\n")

      program = Computer.load(File.read!("data/day11.txt"))

      state =
        Day11.init(program)
        |> Day11.step()

      assert Day11.inspect(state, 2) == expected, Day11.inspect(state, 2)
    end
  end
end
