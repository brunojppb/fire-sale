defmodule FireSale.Notification.LocalNotifier do
  @moduledoc """
  Notifier implementation for local development
  """
  alias FireSale.Notification.ChatNotifier
  require Logger

  @behaviour ChatNotifier

  @impl ChatNotifier
  def send_message(message) do
    Logger.info("Notification: #{message}")
    {:ok, "sent"}
  end
end
