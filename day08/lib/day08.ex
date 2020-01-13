defmodule Day08 do
  @moduledoc """
  Documentation for `Day08`.
  """

  def part1(data, width: width, height: height) do
    data
    |> decode(width: width, height: height)
    |> count_digits()
    |> fewest(0)
    |> checksum(1, 2)
  end

  def decode(data, width: width, height: height) do
    data
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(width * height)
    |> Enum.map(&Enum.chunk_every(&1, width))
  end

  def count_digits(image) do
    image
    |> Enum.map(fn layer ->
      layer
      |> List.flatten()
      |> Enum.reduce(%{}, fn digit, counts -> Map.update(counts, digit, 1, &(&1 + 1)) end)
    end)
  end

  def fewest(layers, needle) do
    Enum.min_by(layers, fn meta -> Map.get(meta, needle) end)
  end

  def checksum(counts, a, b) do
    Map.get(counts, a) * Map.get(counts, b)
  end

  @black 0
  @white 1
  @transparent 2

  def part2(data, width: width, height: height) do
    data
    |> decode(width: width, height: height)
    |> compose(width: width)
  end

  def compose(layers, width: width) do
    layers
    |> Enum.map(&List.flatten/1)
    |> List.zip()
    |> Enum.map(fn pixels ->
      Enum.reduce_while(Tuple.to_list(pixels), @transparent, fn pixel, prev ->
        case pixel do
          ^prev -> {:cont, prev}
          pixel -> {:halt, pixel}
        end
      end)
    end)
    |> Enum.chunk_every(width)
  end

  def render(image) do
    image
    |> Enum.map(fn row -> Enum.map(row, &to_ascii/1) end)
    |> Enum.join("\n")
  end

  def to_ascii(@black), do: "."
  def to_ascii(@white), do: "#"
  def to_ascii(@transparent), do: " "
end
