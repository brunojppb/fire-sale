defmodule FireSaleWeb.Presence do
  use Phoenix.Presence,
    otp_app: :fire_sale,
    pubsub_server: FireSale.PubSub
end
