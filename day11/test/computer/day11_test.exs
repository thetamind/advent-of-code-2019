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

    test "robot follows instructions" do
      expected =
        ~S"""
        .....
        ..<#.
        ...#.
        .##..
        .....
        """
        |> String.trim_trailing("\n")

      program = Computer.load(File.read!("data/day11.txt"))

      state =
        Day11.init(program)
        # Suppose the robot eventually outputs 1 (paint white) and then 0 (turn left).
        |> Day11.paint(:white)
        |> Day11.move(:left)
        # Next, the robot might output 0 (paint black) and then 0 (turn left)
        |> Day11.paint(:black)
        |> Day11.move(:left)
        # After more outputs (1,0, 1,0)
        |> Day11.paint(:white)
        |> Day11.move(:left)
        |> Day11.paint(:white)
        |> Day11.move(:left)
        # After several more outputs (0,1, 1,0, 1,0)
        |> Day11.paint(:black)
        |> Day11.move(:right)
        |> Day11.paint(:white)
        |> Day11.move(:left)
        |> Day11.paint(:white)
        |> Day11.move(:left)

      assert Day11.inspect(state, 2) == expected, Day11.inspect(state, 2)
    end

    test "count panels painted at least once" do
      program = Computer.load(File.read!("data/day11.txt"))

      state =
        Day11.init(program)
        # Suppose the robot eventually outputs 1 (paint white) and then 0 (turn left).
        |> Day11.paint(:white)
        |> Day11.move(:left)
        # Next, the robot might output 0 (paint black) and then 0 (turn left)
        |> Day11.paint(:black)
        |> Day11.move(:left)
        # After more outputs (1,0, 1,0)
        |> Day11.paint(:white)
        |> Day11.move(:left)
        |> Day11.paint(:white)
        |> Day11.move(:left)
        # After several more outputs (0,1, 1,0, 1,0)
        |> Day11.paint(:black)
        |> Day11.move(:right)
        |> Day11.paint(:white)
        |> Day11.move(:left)
        |> Day11.paint(:white)
        |> Day11.move(:left)

      assert Day11.panels_painted(state) == 6, Day11.inspect(state, 2)
    end
  end
end
