defmodule FireSaleWeb.Presence do
  @moduledoc """
  Track presence across the FireSale App
  """
  use Phoenix.Presence,
    otp_app: :fire_sale,
    pubsub_server: FireSale.PubSub
end
