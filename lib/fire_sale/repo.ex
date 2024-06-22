defmodule FireSale.Repo do
  use Ecto.Repo,
    otp_app: :fire_sale,
    adapter: Ecto.Adapters.Postgres
end
