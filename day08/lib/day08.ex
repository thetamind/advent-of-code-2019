defmodule Day08 do
  @moduledoc """
  Documentation for `Day08`.
  """

  def decode(data, width: width, height: height) do
    data
    |> String.to_integer()
    |> Integer.digits()
    |> Enum.chunk_every(width * height)
    |> Enum.map(&Enum.chunk_every(&1, width))
  end
end
