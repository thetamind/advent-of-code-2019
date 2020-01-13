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
    |> String.to_integer()
    |> Integer.digits()
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
end
