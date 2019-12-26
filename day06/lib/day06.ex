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
    [a, b] = String.split(orbit, ")")
    [String.to_atom(a), String.to_atom(b)]
  end

  def count(orbits) do
    Graph.num_vertices(orbits)
  end

  def total_orbits(orbits) do
    Graph.vertices(orbits)
    |> Enum.map(fn v ->
      case Graph.get_shortest_path(orbits, v, :COM) do
        nil -> 0
        path -> Enum.count(path) - 1
      end
    end)
    |> Enum.sum()
  end
end
