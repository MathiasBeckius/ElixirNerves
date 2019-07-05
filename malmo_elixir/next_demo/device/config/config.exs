use Mix.Config

config :device, :device_led_list, [:usr0, :usr1, :usr2]

import_config "#{Mix.env()}.exs"

import_config "../#{Mix.Project.config[:deps][:ui][:path]}/config/config.exs"
#import_config "../#{Mix.Project.config[:deps][:ui][:path]}/config/dev.exs"

