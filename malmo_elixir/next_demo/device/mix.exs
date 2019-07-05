defmodule Device.MixProject do
  use Mix.Project

  def project do
    [
      app: :device,
      version: "0.1.0",
      elixir: "~> 1.8",
      target: Mix.target(),
      deps: deps(Mix.target())
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      env: []
    ]
  end

  defp deps(:host) do
    [
      {:ui, path: "../ui"},
    ]
  end
end
