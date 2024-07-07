defmodule FireSale.Notification.TelegramNotifier do
  @moduledoc """
  Push update messages to the configured Telegram channel
  """

  alias FireSale.Notification.ChatNotifier
  require Logger

  @behaviour ChatNotifier

  @doc """
    Send markdown-style message to Telegram
    See [formatting options](https://core.telegram.org/bots/api#formatting-options)
  """
  @impl ChatNotifier
  def send_message(msg) do
    url = "/sendMessage?chat_id=#{chat_id()}"

    case Req.post(base_req(), url: url, json: %{text: msg}) do
      {:ok, %Req.Response{body: %{"ok" => true}} = _response} ->
        {:ok, "sent"}

      {:ok, response} ->
        Logger.error("Could not notify Telegram resp=#{inspect(response)}")
        {:error, "invalid telegram message"}

      {:error, err} ->
        Logger.error("Error while calling Telegram resp=#{inspect(err)}")
        {:error, "Temp error with Telegram API"}
    end
  end

  defp base_req() do
    Req.new(base_url: "https://api.telegram.org/bot#{token()}")
  end

  defp token() do
    Application.fetch_env!(:fire_sale, :telegram_bot_token)
  end

  defp chat_id() do
    Application.fetch_env!(:fire_sale, :telegram_chat_id)
  end
end
