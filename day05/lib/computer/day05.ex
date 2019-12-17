defmodule Computer.Day05 do
  @moduledoc """
  Documentation for Computer.Day05.

  ## Examples

      iex> result = Computer.run([3,0,4,0,99], %{input: [777]})
      ...> result.output
      [777]

      iex> result = Computer.run([1002,4,3,4,33])
      ...> result.memory
      [1002,4,3,4,99]

      iex> Computer.decode_op(1002)
      {2, :position, :immediate, :position}
  """

  import Computer

  def part1(input) do
    input
    |> load()
    |> run(%{input: [1]})
    |> Map.get(:output)
    |> Enum.at(0)
  end

  def part2(input) do
    %{}
  end
end
