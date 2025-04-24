defmodule NewtailElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :newtail_elixir,
      version: get_version(),
      elixir: "~> 1.14.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "NewtailElixir",
      description: "A library for integrating with Newtail",
      source_url: "https://github.com/petlove/newtail_elixir",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
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
      {:ecto_sql, "~> 3.11.0"},
      {:excoveralls, "~> 0.18", only: :test},
      {:httpoison, "~> 2.0"},
      {:mox, "~> 1.0", only: :test}
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
