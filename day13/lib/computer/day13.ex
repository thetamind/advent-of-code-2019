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
    |> run(%{input: [-1, -1, -1, -1, -1, -1, -1]})
  end

  def insert_quarters(program), do: List.replace_at(program, 0, 2)

  def inspect(computer) do
    computer
    |> output()
    |> parse_tiles()
    |> Enum.filter(fn
      {:score, _score} -> true
      {tile, _x, _y} -> tile == :ball || tile == :paddle
    end)
    |> Kernel.inspect()
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
