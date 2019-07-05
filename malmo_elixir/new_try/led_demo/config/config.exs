use Mix.Config

config :nerves_leds, names: [
  usr0: "beaglebone:green:usr0",
  usr1: "beaglebone:green:usr1",
  usr2: "beaglebone:green:usr2",
  usr3: "beaglebone:green:usr3",
]

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget, :nerves_network],
  app: Mix.Project.config()[:app]

config :ui, UiWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 80],
  secret_key_base: "601Po2sH7hd4RQAxrrJaUyrB6qI2s9Ccf2Vzixq0hSsh2qtOdbq1xeHQeAU2h2ML",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: UiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false

config :phoenix, :json_library, Jason

config :logger, level: :debug

#config :logger, backends: [RingLogger]

# Authorize the device to receive firmware using your public key.
keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [],
  do:
    Mix.raise("""
    No SSH public keys found in ~/.ssh. An ssh authorized key is needed to
    log into the Nerves device and update firmware on it using ssh.
    See your project's config.exs for this error message.
    """)

config :nerves_firmware_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

# Configure nerves_init_gadget.
# Setting the node_name will enable Erlang Distribution.
# Only enable this for prod if you understand the risks.
node_name = if Mix.env() != :prod, do: "led_demo"

config :nerves_init_gadget,
  ifname: "usb0",
  address_method: :dhcpd,
  mdns_domain: "nerves.local",
  node_name: node_name,
  node_host: :mdns_domain

config :nerves_network, :default,
  usb0: [
    ipv4_address_method: :dhcp
  ]

# import_config "#{Mix.target()}.exs"
