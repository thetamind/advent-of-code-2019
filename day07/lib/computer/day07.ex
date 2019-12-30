defmodule Computer.Day07 do
  @moduledoc """
  Documentation for `Computer.Day07`.

  ## Examples

      iex> Computer.Day07.part1("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", [4,3,2,1,0])
      43210

      iex> Computer.Day07.part1("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0", [0,1,2,3,4])
      54321

      iex> Computer.Day07.part1("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0", [1,0,4,3,2])
      65210

  """

  import Computer

  def part1(input, phases) do
    program = load(input)

    phases
    |> permutations()
    |> Enum.map(fn phases -> thrust(program, phases, [0]) end)
    |> Enum.max()
  end

  def thrust(program, phases, input) do
    Enum.reduce(phases, input, fn phase, input ->
      input = input |> List.wrap() |> List.insert_at(0, phase)
      result = Computer.run(program, %{input: input})
      result.output
    end)
    |> List.first()
  end

  def permutations([]), do: [[]]

  def permutations(list) do
    for x <- list, y <- permutations(list -- [x]), do: [x | y]
  end
end
