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

  def count(tiles, type) do
    Enum.count(tiles, fn {t, _x, _y} -> t == type end)
  end

  def parse_tiles(input) do
    input
    |> Enum.chunk_every(3)
    |> Enum.map(&parse_tile/1)
  end

  def parse_tile([x, y, tile_id]) do
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
