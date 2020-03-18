defmodule Computer.Day13 do
  @moduledoc false

  import Computer

  def part1(string) do
    string
    |> load()
    |> run()
    |> output()
    |> parse_tiles()
    |> count(:block)
  end

  def part2(string) do
    string
    |> load()
    |> insert_quarters()
    |> run()
    |> play_game()
    |> score()
  end

  def insert_quarters(program), do: List.replace_at(program, 0, 2)

  def score(%{score: score}), do: score

  def play_game(computer, state \\ %{}) do
    {output, computer} = consume_output(computer)
    state = Map.merge(state, important_tiles(output))

    case Computer.halted?(computer) do
      true ->
        state

      false ->
        new_computer =
          computer
          |> add_input(joystick(state))
          |> run()

        play_game(new_computer, state)
    end
  end

  defp joystick(state) do
    {ball_x, _y} = Map.get(state, :ball)
    {paddle_x, _y} = Map.get(state, :paddle)

    joystick(ball_x, paddle_x)
  end

  defp joystick(ball_x, paddle_x) do
    cond do
      paddle_x < ball_x -> 1
      paddle_x == ball_x -> 0
      paddle_x > ball_x -> -1
    end
  end

  defp important_tiles(output) do
    output
    |> parse_tiles()
    |> Enum.reduce(%{}, fn
      {:ball, x, y}, acc -> Map.put(acc, :ball, {x, y})
      {:paddle, x, y}, acc -> Map.put(acc, :paddle, {x, y})
      {:score, score}, acc -> Map.put(acc, :score, score)
      _, acc -> acc
    end)
  end

  def count(tiles, type) do
    Enum.count(tiles, fn {t, _x, _y} -> t == type end)
  end

  def parse_tiles(input) do
    input
    |> Enum.chunk_every(3)
    |> Enum.map(&parse_tile/1)
  end

  def parse_tile([x, y, tile_id]) do
    if x == -1 do
      {:score, tile_id}
    else
      tile =
        case tile_id do
          0 -> :empty
          1 -> :wall
          2 -> :block
          3 -> :paddle
          4 -> :ball
        end

      {tile, x, y}
    end
  end
end
