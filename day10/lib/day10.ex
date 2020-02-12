defmodule Day10 do
  @moduledoc false

  def part1(input) do
    input
    |> load()
    |> best_location()
  end

  def part2(input, station) do
    input
    |> load()
    |> giant_rotating_laser(station)
    |> IO.inspect(width: 140, limit: 20)
    |> Enum.at(200)
  end

  def giant_rotating_laser(asteroids, source) do
    Day10.Map.sorted_slopes(asteroids, source)
    |> Map.to_list()
    |> Enum.map(fn {key, points} -> {key, List.first(points)} end)
    |> Enum.sort_by(fn {{_quad, _slope}, value} ->
      {dx, dy} = vector(source, value)
      :math.atan2(dy, dx)
    end)
    |> IO.inspect()
  end

  defp vector({x1, y1}, {x2, y2}) do
    {x2 - x1, y2 - y1}
  end

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
          "X" -> [{x, y} | acc]
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

  def best_location(asteroids) do
    asteroids
    |> Map.new(fn asteroid -> {asteroid, Day10.Map.visible_count(asteroids, asteroid)} end)
    |> Enum.max_by(fn {_asteroid, count} -> count end)
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
    slopes(asteroids, source)
    |> Map.keys()
    |> Enum.count()
  end

  @spec visible?(MapSet.t(), {integer, integer}, {integer, integer}) :: boolean
  def visible?(asteroids, source, target) do
    sorted_slopes = sorted_slopes(asteroids, source)

    # Closest asteroid along slope will be visible, blocking view of others
    target_slope = slope_with_quad(source, target)
    asteroids_along_slope = Map.get(sorted_slopes, target_slope)
    index = Enum.find_index(asteroids_along_slope, fn e -> e == target end)

    index == 0
  end

  def slopes(asteroids, source) do
    Enum.reduce(asteroids, %{}, fn element, acc ->
      case slope_with_quad(source, element) do
        :identity -> acc
        slope -> Map.update(acc, slope, [element], fn xs -> [element | xs] end)
      end
    end)
  end

  def sorted_slopes(asteroids, source) do
    slopes(asteroids, source)
    |> Map.to_list()
    |> Enum.sort_by(fn {{quad, _slope}, _value} -> quad end)
    |> Map.new(fn {key, elements} ->
      sorted_elements = Enum.sort_by(elements, &manhattan(source, &1), :asc)
      {key, sorted_elements}
    end)
  end

  def slope_with_quad({x1, y1}, {x2, y2}) when x1 == x2 and y1 == y2, do: :identity

  def slope_with_quad({x1, y1}, {x2, y2}) do
    run = x2 - x1
    rise = y2 - y1

    quad =
      cond do
        pos(run) and neg(rise) -> :I
        neg(run) and neg(rise) -> :II
        neg(run) and pos(rise) -> :III
        pos(run) and pos(rise) -> :IV
      end

    slope =
      case run do
        0 -> if rise > 0, do: :up, else: :down
        run -> rise / run
      end

    {quad, slope}
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

  def manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp pos(num), do: num >= 0
  defp neg(num), do: not pos(num)
end
