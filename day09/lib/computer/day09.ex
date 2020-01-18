defmodule Computer.Day09 do
  @moduledoc """
  Documentation for `Computer.Day09`.

  ## Part 1 Examples

      iex> program = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
      ...> ^program = Computer.run(program) |> Computer.output()

      iex> program = [1102,34915192,34915192,7,4,7,99,0]
      ...> output = Computer.run(program) |> Computer.output() |> List.first()
      ...> Integer.digits(output) |> Enum.count()
      16

      iex> program = [104,1125899906842624,99]
      ...> Computer.run(program) |> Computer.output() |> List.first()
      1125899906842624

  """

  import Computer

  def part1(input) do
    input
    |> load()
    |> Computer.run(%{input: [1]})
    |> IO.inspect(width: 160, limit: 300)
    |> Computer.output()
  end
end
