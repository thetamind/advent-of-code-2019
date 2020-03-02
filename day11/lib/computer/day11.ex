defmodule Computer.Day11 do
  @moduledoc false

  import Computer

  defstruct computer: nil, pos: {0, 0}, dir: :north

  @type position :: {integer(), integer()}
  @type t :: %__MODULE__{computer: Computer.t(), pos: position()}

  def part1(input) do
    input
    |> load()
    |> Computer.run(%{input: [1]})
    |> Computer.output()
  end

  def init(program) do
    %__MODULE__{computer: Computer.new(program, %{})}
  end

  def inspect(state, radius) do
    for y <- -radius..radius do
      for x <- -radius..radius do
        point = {x, y}
        if state.pos == point, do: "^", else: "."
      end
    end
    |> Enum.join("\n")
  end
end
