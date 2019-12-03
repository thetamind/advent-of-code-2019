defmodule Day03 do
  @moduledoc false

  def part1(input) do
    input
    # path to coordinates to [wire]
    |> parse_to_wires()

    # |> wires_to_intersections()
    # |> closest_intersection_distance()

    # 0
  end

  def parse_to_wires(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&string_to_wire/1)
  end

  defp string_to_wire(string) do
    string
    |> String.split(",", trim: true)
    |> Enum.map(&parse_direction/1)
  end

  defp parse_direction(<<dir::8, length::binary>>) do
    direction =
      case <<dir>> do
        "U" -> :up
        "D" -> :down
        "L" -> :left
        "R" -> :right
      end

    {direction, String.to_integer(length)}
  end
end
