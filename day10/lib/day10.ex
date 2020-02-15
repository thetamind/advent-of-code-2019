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
    |> Enum.at(200)
  end

  def giant_rotating_laser(asteroids, source) do
    asteroid_groups =
      Day10.Map.sorted_slopes(asteroids, source)
      |> Day10.Map.transpose_map()

    asteroid_groups
    |> Enum.map(&rotate_laser(&1, source))
    |> List.flatten()
  end

  def rotate_laser(asteroid_group, source) do
    asteroids =
      asteroid_group
      |> Enum.map(fn {key, value} ->
        vector = vector(source, value)
        atan2 = atan2(vector)
        {key, value, vector, atan2}
      end)
      |> Enum.sort_by(fn {{quad, _slope}, _value, _vector, atan2} ->
        {quad, atan2}
      end)
      |> Enum.reverse()

    index =
      Enum.find_index(asteroids, fn {{q, _slope}, _value, _vector, atan2} ->
        q == :I && atan2 <= :math.pi() * 1.5
      end)

    {a, b} = Enum.split(asteroids, index)

    (b ++ a)
    |> List.flatten()
    |> Enum.map(fn {_slope, position, _vector, _atan2} -> position end)
  end

  defp vector({x1, y1}, {x2, y2}) do
    # Invert y to give math-normal positive y is up
    {x2 - x1, y1 - y2}
  end

  defp atan2({dx, dy}) do
    :math.atan2(dy, dx) + :math.pi()
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
    # Invert y to give math-normal positive y is up
    rise = y1 - y2

    quad =
      cond do
        pos(run) and pos(rise) -> :I
        neg(run) and pos(rise) -> :II
        neg(run) and neg(rise) -> :III
        pos(run) and neg(rise) -> :IV
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

  def transpose_map(map) do
    map
    |> Enum.map(fn {k, values} ->
      Enum.map(values, fn v -> {k, v} end)
    end)
    |> transpose()
  end

  # this crazy clever algorithm hails from
  # http://stackoverflow.com/questions/5389254/transposing-a-2-dimensional-matrix-in-erlang
  # and is apparently from the Haskell stdlib. I implicitly trust Haskellers.
  def transpose([[x | xs] | xss]) do
    [[x | for([h | _] <- xss, do: h)] | transpose([xs | for([_ | t] <- xss, do: t)])]
  end

  def transpose([[] | xss]), do: transpose(xss)

  def transpose([]), do: []
end
