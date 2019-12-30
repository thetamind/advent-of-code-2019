defmodule Computer.Day07 do
  @moduledoc false

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
