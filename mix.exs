defmodule NewtailElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :newtail_elixir,
      version: get_version(),
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "NewtailElixir",
      description: "A library for integrating with Newtail",
      source_url: "https://github.com/petlove/newtail_elixir",
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {NewtailElixir.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 2.0"}
    ]
  end

  defp package do
    [
      name: :newtail_elixir,
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/petlove/newtail_elixir"},
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG* VERSION*)
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp get_version do
    case File.read("VERSION") do
      {:ok, version} -> String.trim(version)
      _ -> "0.0.0-unknown"
    end
  end
end
