defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  def part1_example() do
    ~S"""
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
  end

  test "load" do
    orbits = Day06.load(part1_example())
    assert Day06.count(orbits) == 12
  end

  test "part 1 example" do
    orbits = Day06.load(part1_example())
    assert Day06.total_orbits(orbits) == 42
  end

  test "part 1 solution" do
    path = Path.expand("data/input.txt")
    orbits = Day06.load(File.read!(path))
    assert Day06.total_orbits(orbits) == 145_250
  end
end
