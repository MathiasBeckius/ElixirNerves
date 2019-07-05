defmodule Device.Led do
  alias Device.Led.Interface

  defdelegate valid?(led), to: Interface
  defdelegate on(led),     to: Interface
  defdelegate off(led),    to: Interface
end
