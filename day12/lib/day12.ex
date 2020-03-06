defmodule Day12 do
  @moduledoc false

  def load(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&to_moon/1)
  end

  @spec to_moon(binary) :: {integer(), integer(), integer()}
  def to_moon(line) do
    line
    |> String.split(["<", ">", ","])
    |> Enum.map(&String.trim/1)
    |> parts_to_tuple()
  end

  defp parts_to_tuple([_, x, y, z, _]) do
    {extract(x), extract(y), extract(z)}
  end

  defp extract(<<_::8*2, number::binary>>) do
    String.to_integer(number)
  end
end
