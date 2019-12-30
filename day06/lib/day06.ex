defmodule Day06 do
  @moduledoc """
  Documentation for Day06.
  """

  require Graph

  @spec load(binary) :: Graph.t()
  def load(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_orbit/1)
    |> Enum.reduce(Graph.new(), fn [a, b], graph ->
      Graph.add_edge(graph, b, a)
    end)
  end

  defp parse_orbit(orbit) do
    String.split(orbit, ")")
  end

  def count(orbits) do
    Graph.num_vertices(orbits)
  end

  def total_orbits(orbits) do
    Graph.vertices(orbits)
    |> Enum.reduce(0, fn v, acc ->
      count(orbits, v, acc)
    end)
  end

  defp count(orbits, v, acc) do
    case Graph.out_neighbors(orbits, v) do
      [] -> acc
      [body] -> count(orbits, body, acc + 1)
    end
  end

  def transfers(orbits) do
    my_path = Graph.get_shortest_path(orbits, "YOU", "COM")
    santa_path = Graph.get_shortest_path(orbits, "SAN", "COM")
    santa_lookup = MapSet.new(santa_path)

    common =
      Enum.find(my_path, fn planet ->
        MapSet.member?(santa_lookup, planet)
      end)

    my_index = Enum.find_index(my_path, &(&1 == common))
    santa_index = Enum.find_index(santa_path, &(&1 == common))

    my_slice = Enum.split(my_path, my_index + 1) |> elem(0)
    santa_slice = Enum.split(santa_path, santa_index + 1) |> elem(0)

    Enum.count(my_slice) + Enum.count(santa_slice) - 4
  end
end
