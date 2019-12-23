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
    [:COM, String.to_atom(<<b>>)]
  end

  defp parse_orbit(<<a::8, _p::8, b::8>>) do
    [String.to_atom(<<a>>), String.to_atom(<<b>>)]
  end

  def count(orbits) do
    Graph.num_vertices(orbits)
  end
end
