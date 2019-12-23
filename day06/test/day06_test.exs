defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  test "load" do
    input = ~S"""
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    """

    orbits = Day06.load(input)
    assert Day06.count(orbits) == 12
  end
end
