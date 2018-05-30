defmodule FiveCardDraw.Mixfile do
  use Mix.Project

  def project do
    [app: :five_card_draw,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:cowboy, :plug],
     extra_applications: [:logger],
     mod: {FiveCardDraw.Application, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:excoveralls, "~> 0.8", only: :test},
     {:plug, "~> 1.0"},
     { :uuid, "~> 1.1" },
     {:shorter_maps, "~> 2.0"},]
  end
end
