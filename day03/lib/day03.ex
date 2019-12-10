defmodule Day03 do
  @moduledoc false

  # input:    "R8,U5,D4,L4\n"
  # tokens:   [right: 8, up: 5, down: 4, left: 4]
  # vectors:  [{8,0}, {0,5}, {0,-4}, {-4,0}]
  # points:   [{0,0}, {8,0}, {8,5}, {8,1}, {4,1}]
  # segments: {0,0}-{8,0}, {8,0}-{8,5}, {8,5}-{8,1}, ...
  # Enum.member?(wire, {8,4}) => true
  # cross(seg1, seg2) => {8,3}

  def part1(input) do
    input
    |> load()
    |> wires_to_intersections()
    |> closest_intersection_distance()
  end

  def part2(input) do
    input
    |> load()
    |> Day03.Wire.intersections_with_steps()
    |> shortest_path_length()
  end

  def shortest_path_length(intersections) do
    -1
  end

  def closest_intersection_distance(intersections) do
    intersections
    |> Enum.map(&manhattan(&1, {0, 0}))
    |> Enum.min()
  end

  def manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def load(input) do
    input
    |> parse_to_tokens()
    |> Enum.map(&tokens_to_vectors/1)
    |> Enum.map(&Day03.Wire.from_vectors/1)
  end

  def tokens_to_vectors(tokens) do
    Enum.map(tokens, &token_to_vector/1)
  end

  def token_to_vector({dir, length}) do
    case dir do
      :up -> {0, length}
      :down -> {0, -length}
      :right -> {length, 0}
      :left -> {-length, 0}
    end
  end

  def wires_to_intersections([wire1, wire2] = _wires) do
    Day03.Wire.intersections(wire1, wire2)
  end

  def parse_to_tokens(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&string_to_tokens/1)
  end

  def string_to_tokens(string) do
    string
    |> String.split(",", trim: true)
    |> Enum.map(&parse_direction/1)
  end

  def parse_direction(<<dir::8, length::binary>>) do
    direction =
      case <<dir>> do
        "U" -> :up
        "D" -> :down
        "L" -> :left
        "R" -> :right
      end

    {direction, String.to_integer(length)}
  end

  defmodule Wire do
    defstruct points: [], steps: []

    def from_vectors(vectors) do
      points =
        Enum.scan([{0, 0} | vectors], fn {x1, y1}, {x2, y2} ->
          {x1 + x2, y1 + y2}
        end)

      steps =
        vectors
        |> List.insert_at(0, {0, 0})
        |> Enum.scan(0, fn {x, y}, steps -> steps + abs(x) + abs(y) end)

      %Wire{points: points, steps: steps}
    end

    def member?(wire, {xn, yn} = _needle) do
      Enum.find_value(segments(wire), false, fn [{x1, y1}, {x2, y2}] ->
        cond do
          x1 == x2 and x1 == xn ->
            Enum.member?(y1..y2, yn)

          y1 == y2 and y1 == yn ->
            Enum.member?(x1..x2, xn)

          true ->
            false
        end
      end)
    end

    def segments_with_steps(wire) do
      wire
      |> segments()
      |> Enum.zip(Enum.drop(wire.steps, 1))
    end

    def intersections_with_steps([wire1, wire2]), do: intersections_with_steps(wire1, wire2)

    def intersections_with_steps(wire1, wire2) do
      segments1 = segments_with_steps(wire1)
      segments2 = segments_with_steps(wire2)

      segments1
      |> Enum.reduce([], fn segment, acc ->
        found =
          segments2
          |> Enum.map(&find_intersections_with_steps(segment, &1))
          |> Enum.reject(&Kernel.is_nil/1)
          |> Enum.reject(fn {x, y} -> x == 0 and y == 0 end)

        [found | acc]
      end)
      |> List.flatten()
    end

    def find_intersections_with_steps({segment1, steps1}, {segment2, steps2}) do
    end

    def find_intersection2(segmentA, segmentB) do
      [{ax1, ay1}, {ax2, ay2}] = segmentA
      [{bx1, by1}, {bx2, by2}] = segmentB

      cond do
        horizontal?(segmentA) and vertical?(segmentB) ->
          if Enum.member?(Range.new(ax1, ax2), bx1) and Enum.member?(Range.new(by1, by2), ay1) do
            {bx1, ay1}
          end

        vertical?(segmentA) and horizontal?(segmentB) ->
          if Enum.member?(Range.new(bx1, bx2), ax1) and Enum.member?(Range.new(ay1, ay2), by1) do
            {ax1, by1}
          end
      end
    end

    def intersections(wire1, wire2) do
      segments2 = segments(wire2)

      segments(wire1)
      |> Enum.reduce([], fn segment, acc ->
        found =
          segments2
          |> Enum.filter(&cover?(segment, &1))
          |> Enum.map(&find_intersection(segment, &1))
          |> Enum.reject(&Kernel.is_nil/1)
          |> Enum.reject(fn {x, y} -> x == 0 and y == 0 end)

        [found | acc]
      end)
      |> List.flatten()
    end

    def find_intersection(segment1, segment2) do
      {segmentA, segmentB} =
        cond do
          horizontal?(segment1) -> {segment1, segment2}
          vertical?(segment1) -> {segment2, segment1}
        end

      [{ax1, ay}, {ax2, _ay}] = segmentA
      [{bx, by1}, {_bx, by2}] = segmentB

      if Enum.member?(Range.new(ax1, ax2), bx) and Enum.member?(Range.new(by1, by2), ay) do
        {bx, ay}
      end
    end

    def cover?(self, other) do
      cond do
        horizontal?(self) and vertical?(other) ->
          true

        vertical?(self) and horizontal?(other) ->
          true

        true ->
          false
      end
    end

    def horizontal?([{_x1, y1}, {_x2, y2}]) when y1 == y2, do: true
    def horizontal?(_), do: false
    def vertical?([{x1, _y1}, {x2, _y2}]) when x1 == x2, do: true
    def vertical?(_), do: false

    def segments(wire) do
      Enum.chunk_every(wire.points, 2, 1, :discard)
    end
  end
end
