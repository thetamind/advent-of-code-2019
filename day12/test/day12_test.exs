defmodule Day12Test do
  use ExUnit.Case

  import Day12
  alias Day12.{Moon, Simulation, Velocity}

  @example1 ~S"""
  <x=-1, y=0, z=2>
  <x=2, y=-10, z=-7>
  <x=4, y=-8, z=8>
  <x=3, y=5, z=-1>
  """

  @example2 ~S"""
  <x=-8, y=-10, z=0>
  <x=5, y=5, z=10>
  <x=2, y=-7, z=3>
  <x=9, y=-8, z=-3>
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

    test "gravity" do
      ganymede = Moon.new({3, 9, 0})
      callisto = Moon.new({5, 9, 0})

      {vel_g, vel_c} = Moon.velocity_from_gravity(ganymede, callisto)

      assert vel_g == Velocity.new({1, 0, 0})
      assert vel_c == Velocity.new({-1, 0, 0})
    end

    test "simulation step 1" do
      sim =
        Simulation.new(load(@example1))
        |> Simulation.step()

      velocities = sim.moons |> Enum.map(&Moon.velocity/1)
      positions = sim.moons |> Enum.map(&Moon.position/1)

      assert sim.step == 1
      assert velocities == [{3, -1, -1}, {1, 3, 3}, {-3, 1, -3}, {-1, -3, 1}]
      assert positions == [{2, -1, 1}, {3, -7, -4}, {1, -7, 5}, {2, 2, 0}]
    end
  end

  describe "example 2" do
    test "simulation step 100" do
      sim =
        Simulation.new(load(@example2))
        |> Simulation.at_step(100)

      velocities = sim.moons |> Enum.map(&Moon.velocity/1)
      positions = sim.moons |> Enum.map(&Moon.position/1)

      assert sim.step == 100
      assert velocities == [{-7, 3, 0}, {3, -11, -5}, {-3, 7, 4}, {7, 1, 1}]
      assert positions == [{8, -12, -9}, {13, 16, -3}, {-29, -11, -1}, {16, -13, 23}]
    end
  end
end
