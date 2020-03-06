defmodule Computer.Day11 do
  @moduledoc false

  import Computer

  defstruct computer: nil, pos: {0, 0}, dir: :up, panels: %{}

  @typep position :: {integer(), integer()}
  @typep direction :: :up | :down | :left | :right
  @typep colour :: :black | :white
  @typep panels :: %{optional(position) => colour()}
  @type t :: %__MODULE__{
          computer: Computer.t(),
          pos: position(),
          dir: direction(),
          panels: panels()
        }

  def part1(input) do
    input
    |> load()
    |> Computer.run()
    |> Computer.output()
  end

  def panels_painted(%{panels: panels}) do
    Map.keys(panels) |> Enum.count()
  end

  def init(program) do
    %__MODULE__{computer: Computer.new(program, %{})}
  end

  @spec step(t()) :: t()
  def step(state) do
    input =
      case camera(state) do
        :black -> 0
        :white -> 1
      end

    new_computer =
      state.computer
      |> Computer.add_input(input)
      |> Computer.run()

    {[paint_val, dir_val], new_computer} = Computer.consume_output(new_computer)

    paint =
      case paint_val do
        0 -> :black
        1 -> :white
      end

    dir =
      case dir_val do
        0 -> :left
        1 -> :right
      end

    %{state | computer: new_computer}
    |> paint(paint)
    |> move(dir)
  end

  def camera(%{pos: pos, panels: panels}) do
    Map.get(panels, pos, :black)
  end

  def paint(%{pos: pos, panels: panels} = state, paint) do
    %{state | panels: Map.put(panels, pos, paint)}
  end

  def move(%{pos: pos, dir: dir} = state, turn) do
    new_dir = turn(dir, turn)
    new_pos = drive_forward(pos, new_dir)
    %{state | pos: new_pos, dir: new_dir}
  end

  defp turn(dir, :left), do: turn_left(dir)
  defp turn(dir, :right), do: turn_right(dir)

  defp turn_left(dir) do
    case dir do
      :up -> :left
      :down -> :right
      :left -> :down
      :right -> :up
    end
  end

  defp turn_right(dir) do
    case dir do
      :up -> :right
      :down -> :left
      :left -> :up
      :right -> :down
    end
  end

  defp drive_forward({x, y}, dir) do
    case dir do
      :up -> {x, y - 1}
      :down -> {x, y + 1}
      :left -> {x - 1, y}
      :right -> {x + 1, y}
    end
  end

  defp inspect_dir(dir) do
    case dir do
      :up -> "^"
      :down -> "v"
      :left -> "<"
      :right -> ">"
    end
  end

  defp inspect_panel(panels, pos) do
    case Map.get(panels, pos, :black) do
      :black -> "."
      :white -> "#"
    end
  end

  def inspect(state, radius) do
    for y <- -radius..radius do
      for x <- -radius..radius do
        point = {x, y}

        if state.pos == point,
          do: inspect_dir(state.dir),
          else: inspect_panel(state.panels, point)
      end
    end
    |> Enum.join("\n")
  end
end
