defmodule Day12 do
  @moduledoc false

  defmodule Position do
    defstruct [:x, :y, :z]
    @type t :: %__MODULE__{x: integer(), y: integer(), z: integer()}

    def new({x, y, z}) do
      %__MODULE__{x: x, y: y, z: z}
    end

    def move(%{x: x, y: y, z: z} = pos, %{x: dx, y: dy, z: dz}) do
      %{pos | x: x + dx, y: y + dy, z: z + dz}
    end
  end

  defmodule Velocity do
    defstruct [:x, :y, :z]
    @type t :: %__MODULE__{x: integer(), y: integer(), z: integer()}

    def new({x, y, z}) do
      %__MODULE__{x: x, y: y, z: z}
    end

    def zero() do
      %__MODULE__{x: 0, y: 0, z: 0}
    end

    def invert(%{x: x, y: y, z: z} = vel) do
      %{vel | x: -x, y: -y, z: -z}
    end

    def change(%{x: x, y: y, z: z} = vel, %{x: dx, y: dy, z: dz}) do
      %{vel | x: x + dx, y: y + dy, z: z + dz}
    end
  end

  defmodule Moon do
    @enforce_keys [:position, :velocity]
    defstruct [:position, :velocity]

    @type t :: %__MODULE__{
            position: Position.t(),
            velocity: Velocity.t()
          }
    def new(pos) do
      %__MODULE__{position: Position.new(pos), velocity: Velocity.zero()}
    end

    def total_energy(moon) do
      potential_energy(moon) * kinetic_energy(moon)
    end

    def potential_energy(%{position: pos}), do: energy(pos)

    def kinetic_energy(%{velocity: vel}), do: energy(vel)

    defp energy(%{x: x, y: y, z: z}) do
      abs(x) + abs(y) + abs(z)
    end

    def move(%{position: pos, velocity: vel} = moon) do
      %{moon | position: Position.move(pos, vel)}
    end

    def change_velocity(%{velocity: vel} = moon, change) do
      %{moon | velocity: Velocity.change(vel, change)}
    end

    def velocity_from_gravity(moon_a, moon_b) do
      {xa, ya, za} = position(moon_a)
      {xb, yb, zb} = position(moon_b)

      dx = pull(xa, xb)
      dy = pull(ya, yb)
      dz = pull(za, zb)

      vel_a = Velocity.new({dx, dy, dz})

      {vel_a, Velocity.invert(vel_a)}
    end

    def pull(a, b) when is_integer(a) and is_integer(b) do
      cond do
        a < b -> +1
        a == b -> 0
        a > b -> -1
      end
    end

    def position(%{position: %{x: x, y: y, z: z}}), do: {x, y, z}
    def velocity(%{velocity: %{x: x, y: y, z: z}}), do: {x, y, z}
  end

  defmodule Simulation do
    defstruct step: 0, moons: []
    @type t :: %__MODULE__{step: non_neg_integer(), moons: [Moon.t()]}

    def new(positions) do
      moons =
        positions
        |> Enum.map(&Moon.new/1)

      %__MODULE__{step: 0, moons: moons}
    end

    def get_moon(sim, index) do
      Enum.at(sim.moons, index)
    end

    def total_energy(sim) do
      sim.moons
      |> Enum.map(&Moon.total_energy/1)
      |> Enum.sum()
    end

    def stream(sim) do
      Stream.iterate(sim, &step/1)
    end

    def at_step(sim, target_step) do
      if target_step < sim.step do
        msg = "Cannot run simulator (at step #{sim.step}) backwards to reach target step #{target_step}"
        raise(ArgumentError, msg)
      end

      Enum.at(stream(sim), target_step - sim.step)
    end

    def step(%{step: step, moons: moons} = sim) do
      new_moons =
        moons
        |> apply_gravity()
        |> apply_velocity()

      %{sim | step: step + 1, moons: new_moons}
    end

    def apply_gravity(moons) do
      moons = Array.from_list(moons) |> Array.fix()
      pairs = pairs(Enum.to_list(0..(Array.size(moons) - 1)))

      changes =
        pairs
        |> Enum.map(fn [index_a, index_b] ->
          moon_a = Array.get(moons, index_a)
          moon_b = Array.get(moons, index_b)
          {vel_a, vel_b} = Moon.velocity_from_gravity(moon_a, moon_b)

          [{vel_a, index_a}, {vel_b, index_b}]
        end)
        |> List.flatten()

      Enum.reduce(changes, moons, fn {change, index}, acc ->
        Array.update(acc, index, fn moon -> Moon.change_velocity(moon, change) end)
      end)
      |> Array.to_list()
    end

    def apply_velocity(moons) do
      Enum.map(moons, &Moon.move/1)
    end

    defp pairs(list) when is_list(list), do: comb(2, list)

    @spec comb(non_neg_integer(), Enum.t()) :: [Enum.t()]
    defp comb(0, _), do: [[]]
    defp comb(_, []), do: []

    defp comb(m, [h | t]) do
      for(l <- comb(m - 1, t), do: [h | l]) ++ comb(m, t)
    end
  end

  def find_repeat(target_sim) do
    target_moons = target_sim.moons

    target_sim
    |> Simulation.stream()
    |> Stream.drop(1)
    |> Enum.find(fn sim ->
      sim.moons == target_moons
    end)
  end

  def load(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  @spec parse_line(binary) :: {integer(), integer(), integer()}
  defp parse_line(line) do
    line
    |> String.split(["<", ">", ","])
    |> Enum.map(&String.trim/1)
    |> parts_to_tuple()
  end

  defp parts_to_tuple([_, x, y, z, _]) do
    {extract(x), extract(y), extract(z)}
  end

  defp extract(<<_::8*2, number::binary>>) do
    String.to_integer(number)
  end
end
