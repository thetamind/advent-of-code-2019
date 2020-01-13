defmodule Day08Test do
  use ExUnit.Case

  test "part 1 example" do
    assert Day08.decode("123456789012", width: 3, height: 2) == [
             [[1, 2, 3], [4, 5, 6]],
             [[7, 8, 9], [0, 1, 2]]
           ]

    assert Day08.part1("123456789012", width: 3, height: 2) == 1
  end

  test "part 1 solution" do
    input = File.read!("data/input.txt") |> String.trim_trailing("\n")

    assert Day08.part1(input, width: 25, height: 6) == 2520
  end

  test "part 2 decode leading/trailing zeros" do
    assert Day08.decode("0222112222120000", width: 2, height: 2) ==
             [
               [[0, 2], [2, 2]],
               [[1, 1], [2, 2]],
               [[2, 2], [1, 2]],
               [[0, 0], [0, 0]]
             ]
  end

  test "part 2 example" do
    assert Day08.part2("0222112222120000", width: 2, height: 2) == [[0, 1], [1, 0]]
  end

  test "part 2 solution" do
    input = File.read!("data/input.txt") |> String.trim_trailing("\n")

    Day08.part2(input, width: 25, height: 6)
    |> IO.inspect()
  end
end
