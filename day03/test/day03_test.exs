defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  test "part 1 examples" do
    assert Day03.part1("R8,U5,L5,D3\nU7,R6,D4,L4") == 159

    assert Day03.part1("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83") ==
             159

    assert Day03.part1(
             "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
           ) == 135
  end

  test "part 1 result" do
    input = File.read!("data/input.txt")
    assert Day03.part1(input) == 0
  end

  test "parse_to_tokens" do
    assert Day03.parse_to_tokens("R8,U5,L5,D3\nU7,R6,D4,L4") == [
             [{:right, 8}, {:up, 5}, {:left, 5}, {:down, 3}],
             [{:up, 7}, {:right, 6}, {:down, 4}, {:left, 4}]
           ]
  end

  test "load" do
    [wire1, wire2] = Day03.load("R8,U5,L5,D3\nU7,R6,D4,L4")
    assert Day03.Wire.member?(wire1, {0, 0})
    assert Day03.Wire.member?(wire1, {4, 0})
    assert Day03.Wire.member?(wire1, {8, 0})
    refute Day03.Wire.member?(wire1, {9, 0})

    assert Day03.Wire.member?(wire2, {0, 2})
    assert Day03.Wire.member?(wire2, {2, 3})
    refute Day03.Wire.member?(wire2, {1, 2})
    refute Day03.Wire.member?(wire2, {1, 1})
    assert Day03.Wire.member?(wire2, {-1, -1}) == false
  end

  test "wires_to_intersections" do
    wires = Day03.load("R8,U5,L5,D3\nU7,R6,D4,L4")
    assert Day03.wires_to_intersections(wires) == [{3, 3}, {6, 5}]
  end

  test "manhattan" do
  end
end
