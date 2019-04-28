# Introduction to Nerves: LED demo

## Introduction
In this tutorial we're going to:
* Create a Nerves project from scratch.
* Prepare an SD-card that will be used to boot our Nerves system from (i.e. the BEAM).
* Operate the built-in LED's on a [Beaglebone Black](https://beagleboard.org/black).
* Upload new firmware via SSH.

Equipment:
* Beaglebone Black
* USB-cable, to be connected between Beaglebone Black and your PC.

Prerequisites:
* Elixir and Nerves are already installed.

Although this tutorial will focus on a Beaglebone Black, this can easily be adapted e.g. for a Raspberry Pi board.

I'm using Linux (Ubuntu) for this tutorial.

## Create a Nerves project
First, make sure that your Nerves archive is up-to-date:
```
mix local.nerves
```
Create a new project, we'll call it *led_demo*:
```
mix nerves.new led_demo --init-gadget
```
This will give us a whole lot of basic stuff, such support for mDNS support and over-the-air firmware update. Read more at [https://github.com/nerves-project/nerves_init_gadget](https://github.com/nerves-project/nerves_init_gadget).

The auto-generated code will also provide support for different hardware targets. If we only want to create a project for the Beaglebone Black, we can also do the following (by specifying target):
```
mix nerves.new led_demo --init-gadget --target bbb
```


