defmodule Day12 do
  @moduledoc false

  defmodule Position do
    defstruct [:x, :y, :z]
    @type t :: %__MODULE__{x: integer(), y: integer(), z: integer()}

    def new({x, y, z}) do
      %__MODULE__{x: x, y: y, z: z}
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
