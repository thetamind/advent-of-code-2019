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
end
