defmodule Device.Led.HostImplementation do
  @behaviour Device.Led.Interface
  require Logger

  def on(led) do
    Logger.debug "HostImplementation: Turn #{led} on."
    {:ok}
  end

  def off(led) do
    Logger.debug "HostImplementation: Turn #{led} off."
    {:ok}
  end
end

