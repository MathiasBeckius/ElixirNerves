# Introduction to Nerves: LED demo

## Introduction
In this tutorial we're going to:
* Create a Nerves project from scratch.
* Prepare an SD card that will be used for booting our Nerves system.
* Operate the built-in LED's on a [Beaglebone Black](https://beagleboard.org/black), using the [Nerves.Leds library](https://hexdocs.pm/nerves_leds/Nerves.Leds.html).
* Upload new firmware via SSH.

Equipment:
* Beaglebone Black
* USB-cable, to be connected between Beaglebone Black and your PC.
* Micro-SD card (the firmware will take ~25 Megabytes of disk space)

Prerequisites:
* Elixir and Nerves are already installed.
* SSH key is created, SSH agent is up and running.

Although this tutorial will focus on a Beaglebone Black, this can easily be adapted e.g. for a Raspberry Pi board.

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
Since we will communicate with the Beaglebone over SSH, we must make sure that the SSH configuration is in order.
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
Now, run this command to make sure that the dependencies are correct:
```
mix deps.get
```
If you didn't specify target when you created the project, run this first:
```
export MIX_TARGET=bbb
```
You can also do the following:
```
MIX_TARGET=bbb mix deps.get
```

## Build firmware and create bootable SD card
Build firmware:
```
MIX_TARGET=bbb mix firmware
```
Insert a micro-SD card and run (assuming that only one SD card is inserted):
```
MIX_TARGET=bbb mix firmware.burn
```
Take out the SD card, insert it into to your Beaglebone Black (not powered), and boot from the SD card (read more at http://beagleboard.org/getting-started).

## Connect to the Beaglebone Black
The Nerves system starts in a second or two, but it will take 1.5-2 minutes before we can connect to the Beaglebone Black. In this case, an Ethernet-over-USB connection will be automatically setup. By default, the DNS name of the target hardware is **nerves.local**. Ping the device, and you'll see when the device is ready.

Connect by running:
```
ssh nerves.local
```
If successful, you will now be inside the Elixir terminal that runs on the Beaglebone.

The Nerves.Leds library will later be used to manipulate the LED's listed in **/sys/class/leds**. Let's list that directory:
```
ls "/sys/class/leds"
```
You'll see four directories, named "beaglebone:green:usr0", "beaglebone:green:usr1", etc. Remember these names.

Exit the terminal session by typing ```exit```, followed by ENTER.

## LED configuration
The built-in LED's on the Beaglebone Black are called USR0, USR1, USR2 and USR3 (see https://beagleboard.org/getting-started#step1).

We have to define these LED's in **config/config.exs**:
```elixir
config :nerves_leds, names: [
  usr0: "beaglebone:green:usr0",
  usr1: "beaglebone:green:usr1",
  usr2: "beaglebone:green:usr2",
  usr3: "beaglebone:green:usr3",
]
```
Our definitions, i.e. the names we'll use when operating the LED's, are found to the left while the LED's directories (in the /sys/class/leds directory) are found to the right.

Rebuild the firmware:
```
MIX_TARGET=bbb mix firmware
```

## Upload new firmware
Since we have configured the original firmware (that we booted from the SD card) for updates over SSH, we don't have take out the SD card and update it.

First, we have to generate an uploader script:
```
MIX_TARGET=bbb mix firmware.gen.script
```
Now we're able to upload the new firmware:
```
./upload.sh nerves.local _build/bbb_dev/nerves/images/led_demo.fw
```
After the firmware is uploaded, the Beaglebone will reset.

## Time for playing with LED's
Connect to the Beaglebone.

By default, the USR0 LED is blinking in a "heartbeat" pattern. To turn the LED off, run the following:
```
Nerves.Leds.set usr0: false
```
When the LED was turned off, the Nerves.Leds library is actually writing to a file called **brightness**, located in the **/sys/class/leds/beaglebone:green:usr0** directory. In fact, we can read the current value by reading this file:
```
File.read!("/sys/class/leds/beaglebone:green:usr0/brightness")
```
The file should now contain "0\n".

Turn the LED on:
```
Nerves.Leds.set usr0: true
```
Read the same file again. The contents should now be "1\n".

There are also different patterns for blinking the LED's. Read more at [https://hexdocs.pm/nerves_leds/Nerves.Leds.html](https://hexdocs.pm/nerves_leds/Nerves.Leds.html).

## Source code
The source code can be found [here](./led_demo).

## References
https://beagleboard.org/black

https://hexdocs.pm/nerves/getting-started.html

https://github.com/nerves-project/nerves_init_gadget

https://github.com/nerves-project/nerves_firmware_ssh

https://hexdocs.pm/nerves_leds/Nerves.Leds.html

https://github.com/nerves-project/nerves_leds

## Notes
These instructions have been verified on a Linux system (Ubuntu), running Elixir 1.8.1, Nerves Bootstrap 1.5.0 and Nerves 1.4.3.
