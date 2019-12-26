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
      Graph.add_edge(graph, a, b)
    end)
  end

  defp parse_orbit("COM)" <> <<b::8>>) do
    [String.to_atom(<<b>>), :COM]
  end

  defp parse_orbit(<<a::8, _p::8, b::8>>) do
    [String.to_atom(<<b>>), String.to_atom(<<a>>)]
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
