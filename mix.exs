defmodule LetterboxdCal.Mixfile do
  use Mix.Project

  def project do
    [app: :letterboxd_cal,
     version: "0.0.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :logger,
        :httpoison,
        :moebius,
        :cowboy,
        :plug,
        :timex,
        :quantum
      ],
      mod: {LetterboxdCal, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:credo, "~> 0.9.0", only: [:dev, :test]},
      {:floki, "~> 0.8.1"},
      {:moebius, "~> 2.0.3"},
      {:plug, "~> 1.1.4"},
      {:cowboy, "~> 1.0.4"},
      {:httpoison, "~> 0.8.0"},
      {:poison, "~> 2.0.1"},
      {:quantum, ">= 0.7.1"},
    ]
  end
end
