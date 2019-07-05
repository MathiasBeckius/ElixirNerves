defmodule LedDemo.MixProject do
  use Mix.Project

  @all_targets [:bbb]

  def project do
    [
      app: :led_demo,
      version: "0.1.0",
      elixir: "~> 1.8",
      archives: [nerves_bootstrap: "~> 1.5"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  def application do
    [
      mod: {LedDemo.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.4", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},
      {:nerves_network, "~> 0.3"},
      {:ui, path: "../ui"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      {:nerves_leds, "~> 0.8.0", targets: @all_targets},
      {:nerves_firmware_ssh, "~> 0.3", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_bbb, "~> 2.0", runtime: false, targets: :bbb},
    ]
  end
end
