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
    # path to coordinates to [wire]
    |> parse_to_tokens()
    |> Enum.map(&tokens_to_vectors/1)

    # |> Enum.map(&vectors_to_points/1)
    # |> Enum.map(&wires_to_intersections/1)

    # |> closest_intersection_distance()
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

  def wires_to_intersections(wires) do
    wires
    |> Enum.map(&vectors_to_coordinates/1)
  end

  def vectors_to_coordinates(vectors) do
    Enum.reduce(vectors, [], fn vec, acc ->
      nil
    end)
  end

  # defmodule Segment do
  # defstruct first: nil, last: nil

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
end
