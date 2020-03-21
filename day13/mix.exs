defmodule Computer.MixProject do
  use Mix.Project

  def project do
    [
      app: :computer,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        flags: [:unmatched_returns, :error_handling, :race_conditions, :underspecs],
        plt_add_deps: :app_tree,
        plt_add_apps: []
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Computer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:array, github: "thetamind/elixir-array", ref: "913c2e2"},
      {:dialyxir, "~> 1.0.0", only: [:dev], runtime: false}
    ]
  end
end
