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

  @spec visible_count(MapSet.t(), {integer, integer}) :: non_neg_integer
  def visible_count(asteroids, source) do
    slopes =
      Enum.reduce(asteroids, %{}, fn element, acc ->
        case slope(source, element) do
          :identity -> acc
          slope -> Map.update(acc, slope, [element], fn xs -> [element | xs] end)
        end
      end)

    Map.keys(slopes)
    |> Enum.count()
  end

  @spec slope({number, number}, {number, number}) :: :identity | :up | :down | float
  def slope({x1, y1}, {x2, y2}) when x1 == x2 and y1 == y2, do: :identity

  def slope({x1, y1}, {x2, y2}) do
    run = x2 - x1
    rise = y2 - y1

    case run do
      0 -> if rise > 0, do: :up, else: :down
      run -> rise / run
    end
  end
end
