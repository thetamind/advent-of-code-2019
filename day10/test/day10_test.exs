defmodule Day10Test do
  use ExUnit.Case

  doctest Day10

  test "parse" do
    input = ~S"""
    .#..#
    .....
    #####
    ....#
    ...##
    """

    asteroids = Day10.parse(input)

    assert Enum.member?(asteroids, {1, 0})
    assert Enum.member?(asteroids, {4, 0})
    assert Enum.member?(asteroids, {2, 2})
    assert Enum.member?(asteroids, {4, 4})

    refute Enum.member?(asteroids, {0, 0})
    refute Enum.member?(asteroids, {9, 2})
    refute Enum.member?(asteroids, {5, 5})
  end

  test "load" do
    input = ~S"""
    .#..#
    .....
    #####
    ....#
    ...##
    """

    map = Day10.load(input)

    assert Day10.Map.member?(map, 3, 4)
    refute Day10.Map.member?(map, 0, 0)
  end

  test "visible_count" do
    input = ~S"""
    .#..#
    .....
    #####
    ....#
    ...##
    """

    map = Day10.load(input)

    assert Day10.Map.visible_count(map, {3, 4}) == 8
    assert Day10.Map.visible_count(map, {1, 0}) == 7
    assert Day10.Map.visible_count(map, {4, 2}) == 5
  end

  test "visible?" do
    input = ~S"""
    .#..#
    .....
    #####
    ....#
    ...##
    """

    map = Day10.load(input)

    assert Day10.Map.visible?(map, {3, 4}, {2, 2})
    refute Day10.Map.visible?(map, {3, 4}, {1, 0})
  end
end
