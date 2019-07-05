defmodule LedControlPanelWeb.PageController do

  use LedControlPanelWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def set_led(conn, params) do
    led   =
      params["set_led"]["led_list"]
      |> :erlang.binary_to_atom(:utf8)
    state = params["set_led"]["led_state"]
    _set_led(led, state)
    render(conn, "index.html")
  end

  def _set_led(led, _state = "off") do
    Device.Led.off(led)
  end

  def _set_led(led, _state = "on") do
    Device.Led.on(led)
  end
end
