defmodule Device.Led.Interface do
  @implementation Application.get_env(:device, Device.Led)
  @led_list Application.get_env(:device, :device_led_list)

  @doc "Turn the LED on."
  @callback on(led :: atom) :: :ok | :error

  @doc "Turn the LED off."
  @callback off(led :: atom) :: :ok | :error

  def valid?(led) do
    @led_list |> Enum.member?(led)
  end

  def on(led) do
    led_valid? = valid?(led)
    turn_on(led, led_valid?)
  end

  def off(led) do
    led_valid? = valid?(led)
    turn_off(led, led_valid?)
  end

  defp turn_on(led, true),  do: @implementation.on(led)
  defp turn_on(_, false),   do: :error_invalid_led

  defp turn_off(led, true), do: @implementation.off(led)
  defp turn_off(_, false),  do: :error_invalid_led
end
