defmodule Computer.Day02 do
  @moduledoc """
  Documentation for Computer.Day02.

  ## Examples

      iex> Computer.run([1,0,0,0,99]) |> Computer.memory()
      [2,0,0,0,99]

      iex> Computer.run([2,3,0,3,99]) |> Computer.memory()
      [2,3,0,6,99]

      iex> Computer.run([2,4,4,5,99,0]) |> Computer.memory()
      [2,4,4,5,99,9801]

      iex> Computer.run([1,1,1,4,99,5,6,0,99]) |> Computer.memory()
      [30,1,1,4,2,5,6,0,99]

      iex> Computer.run([1,9,10,3,2,3,11,0,99,30,40,50]) |> Computer.memory()
      [3500,9,10,70,2,3,11,0,99,30,40,50]
  """

  import Computer

  def part1(input) do
    input
    |> load()
    |> restore(12, 2)
    |> run()
    |> memory()
    |> Enum.at(0)
  end

  def part2(input) do
    memory =
      input
      |> load()

    for noun <- 0..99, verb <- 0..99 do
      memory
      |> restore(noun, verb)
      |> run()
      |> Map.get(:memory)
      |> Enum.take(3)
    end
    # IDEA: Binary search? Output appears linear
    |> Enum.find_value(fn [output, noun, verb] ->
      if output == 19_690_720, do: 100 * noun + verb
    end)
  end
end
