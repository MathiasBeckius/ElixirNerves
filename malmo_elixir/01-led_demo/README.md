# Introduction to Nerves: LED demo

## Introduction
In this tutorial we're going to:
* Create a Nerves project from scratch.
* Prepare an SD card that will be used to boot our Nerves system from (i.e. the BEAM).
* Operate the built-in LED's on a [Beaglebone Black](https://beagleboard.org/black), using the [Nerves.Leds library](https://hexdocs.pm/nerves_leds/Nerves.Leds.html).
* Upload new firmware via SSH.

Equipment:
* Beaglebone Black
* USB-cable, to be connected between Beaglebone Black and your PC.
* Micro-SD card

Prerequisites:
* Elixir and Nerves are already installed.
* SSH key is created, SSH agent is up and running.

Although this tutorial will focus on a Beaglebone Black, this can easily be adapted e.g. for a Raspberry Pi board.

I'm using Linux (Ubuntu) for this tutorial.

## Create a Nerves project
First, make sure that your Nerves archive is up-to-date:
```
mix local.nerves
```
Create a new project, we'll call it **led_demo**:
```
mix nerves.new led_demo --init-gadget
```
This will give us a whole lot of basic stuff, such as support for mDNS support and firmware update. Read more at [https://github.com/nerves-project/nerves_init_gadget](https://github.com/nerves-project/nerves_init_gadget).

The auto-generated code will also provide support for different hardware targets. If we only want to create a project for the Beaglebone Black, we can also do the following (by specifying target):
```
mix nerves.new led_demo --init-gadget --target bbb
```

## SSH configuration
Enter the project's directory:
```
cd led_demo
```
Since we will update firmware over SSH, we must make sure that the SSH configuration is in order.
Open **config/config.exs**. On rows 31-37, you'll find:
```elixir
keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

```
Make sure that this is in line with your SSH configuration.

## Dependencies
In order to use the Nerves.Leds library and also to be able to update firmware over SSH, we must add dependencies for [nerves_leds](https://github.com/nerves-project/nerves_leds) and [nerves_firmware_ssh](https://github.com/nerves-project/nerves_firmware_ssh) to **mix.exs**. After editing **mix.exs**, the dependency list will look something like this:
```elixir
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.4", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      {:nerves_leds, "~> 0.8.0", targets: @all_targets},
      {:nerves_firmware_ssh, "~> 0.3", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_bbb, "~> 2.0", runtime: false, targets: :bbb},
    ]
  end
```

```elixir
```
```elixir
```
```elixir
```

