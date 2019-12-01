defmodule Day01 do
  def fuel_required(mass) do
    Integer.floor_div(mass, 3) - 2
  end

  def part1() do
    module_masses()
    |> Enum.map(&fuel_required/1)
    |> Enum.sum()
  end

  defp module_masses() do
    Path.expand("../data/input.txt", __DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
