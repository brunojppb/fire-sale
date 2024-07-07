defmodule FireSale.Notification.ChatNotifier do
  @moduledoc """
  Behavior for managing notifications to chat for admin updates
  """
  @type t :: module()

  @doc """
  Send notification message to the configured chat output
  """
  @callback send_message(message :: String.t()) ::
              FireSale.result(String.t())

  @spec send_message(message :: String.t()) ::
          FireSale.result(String.t())
  def send_message(message), do: impl().send_message(message)

  @spec impl() :: __MODULE__.t()
  defp impl() do
    Application.get_env(:fire_sale, :chat_notifier, FireSale.Notification.LocalNotifier)
  end
end
