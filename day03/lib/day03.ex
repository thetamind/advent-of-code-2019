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

    # |> closest_intersection_distance()
  end

  def load(input) do
    input
    |> parse_to_tokens()
    |> Enum.map(&tokens_to_vectors/1)
    |> Enum.map(&Day03.Wire.from_vectors/1)
  end

  # def vectors_to_segments(vectors) do
  #   vectors
  #   |> List.insert_at(0, {0, 0})
  #   |> Enum.chunk_every(2, 1)
  # end

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

  def wires_to_intersections(wires) do
    wires
    |> Enum.map(&vectors_to_coordinates/1)
  end

  def vectors_to_coordinates(vectors) do
    Enum.reduce(vectors, [], fn vec, acc ->
      nil
    end)
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
    defstruct points: []

    def from_vectors(vectors) do
      points =
        Enum.scan([{0, 0} | vectors], fn {x1, y1}, {x2, y2} ->
          {x1 + x2, y1 + y2}
        end)

      %Wire{points: points}
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

    def segments(wire) do
      Enum.chunk_every(wire.points, 2, 1, :discard)
    end
  end
end
