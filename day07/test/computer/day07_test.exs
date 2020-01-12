defmodule Computer.Day07Test do
  use ExUnit.Case, async: true

  doctest Computer.Day07

  test "part 1 solution" do
    input = File.read!("data/day07.txt")
    assert Computer.Day07.part1(input, [0, 1, 2, 3, 4]) == 255_590
  end

  test "part 1 examples" do
    input = File.read!("data/day07.txt")
    program = Computer.load(input)

    assert %{output: [51]} = Computer.run(program, %{input: [3, 0]})
    assert %{output: [560]} = Computer.run(program, %{input: [1, 51]})
    assert %{output: [2815]} = Computer.run(program, %{input: [2, 560]})
    assert %{output: [5636]} = Computer.run(program, %{input: [4, 2815]})
    assert %{output: [140_965]} = Computer.run(program, %{input: [0, 5636]})
  end

  test "part 1 example" do
    phases = [3, 1, 2, 4, 0]
    input = File.read!("data/day07.txt")
    program = Computer.load(input)
    assert 140_965 = Computer.Day07.thrust(program, phases, [0])
  end

  test "part 2 solution" do
    input = File.read!("data/day07.txt")
    assert Computer.Day07.part2(input, [5, 6, 7, 8, 9]) > 42_514_168
  end
end
