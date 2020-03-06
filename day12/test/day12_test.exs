defmodule Day12Test do
  use ExUnit.Case

  import Day12
  alias Day12.{Moon, Simulation}

  @example1 ~S"""
  <x=-1, y=0, z=2>
  <x=2, y=-10, z=-7>
  <x=4, y=-8, z=8>
  <x=3, y=5, z=-1>
  """

  describe "example 1" do
    test "parse moon positions" do
      expected = [
        {-1, 0, 2},
        {2, -10, -7},
        {4, -8, 8},
        {3, 5, -1}
      ]

      assert load(@example1) == expected
    end

    test "load simulation" do
      positions = load(@example1)

      sim = Simulation.new(positions)

      assert Simulation.get_moon(sim, 0) |> Moon.position() == {-1, 0, 2}
      assert Simulation.get_moon(sim, 3) |> Moon.velocity() == {0, 0, 0}
    end
  end
end
