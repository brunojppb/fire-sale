defmodule FireSale.ReservationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FireSale.Reservations` context.
  """

  @doc """
  Generate a reservation.
  """
  def reservation_fixture(attrs \\ %{}) do
    attrs =
      if Map.get(attrs, :product_id) == nil do
        Map.put(attrs, :product_id, FireSale.ProductsFixtures.product_fixture().id)
      else
        attrs
      end

    {:ok, reservation} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        phone: "some phone",
        status: "some status",
        token: "some token"
      })
      |> FireSale.Reservations.create_reservation()

    reservation
  end
end
