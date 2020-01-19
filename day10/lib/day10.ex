defmodule Day10 do
  @moduledoc false

  def parse(string) do
    string
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce([], fn {char, x}, acc ->
        case char do
          "#" -> [{x, y} | acc]
          "." -> acc
        end
      end)
    end)
  end

  def load(string) do
    string
    |> parse()
    |> Day10.Map.new()
  end
end

defmodule Day10.Map do
  def new(points) do
    MapSet.new(points)
  end

  def member?(asteroids, x, y) do
    MapSet.member?(asteroids, {x, y})
  end
end
