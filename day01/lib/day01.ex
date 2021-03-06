defmodule Day01 do
  def fuel_required(mass) do
    Integer.floor_div(mass, 3) - 2
  end

  def part1() do
    module_masses()
    |> Enum.map(&fuel_required/1)
    |> Enum.sum()
  end

  def part2() do
    module_masses()
    |> Enum.map(&total_fuel_required/1)
    |> Enum.sum()
  end

  def total_fuel_required(mass) do
    mass
    |> Stream.iterate(&fuel_required/1)
    # first value is mass
    |> Stream.drop(1)
    |> Enum.take_while(&(&1 > 0))
    |> Enum.sum()
  end

  defp module_masses() do
    Path.expand("../data/input.txt", __DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
