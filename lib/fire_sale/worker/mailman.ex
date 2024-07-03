defmodule FireSale.Worker.Mailman do
  @moduledoc """
  Worker for sending emails in the background during reservation attempts
  """

  alias FireSale.Products.Product
  alias FireSale.Products.ReservationNotifier
  alias FireSale.Products.Reservation
  use Oban.Worker, queue: :default, max_attempts: 1, tags: ["reservations"]
  import Ecto.Query
  require Logger

  @impl true
  def perform(%Oban.Job{args: %{"reservation_id" => id, "url" => url}} = _args) do
    query =
      from r in Reservation,
        join: p in Product,
        on: r.product_id == p.id,
        where: r.id == ^id,
        select: {r.name, r.email, p.name}

    result = FireSale.Repo.one(query)

    case result do
      nil ->
        Logger.debug("Could not find reservation with id #{id}")
        :ok

      {name, email, product_name} ->
        ReservationNotifier.deliver_reservation_instructions(name, email, product_name, url)
        Logger.info("Sending reservation email to #{email}")
        :ok
    end
  end
end
