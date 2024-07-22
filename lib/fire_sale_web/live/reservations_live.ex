defmodule FireSaleWeb.ReservationsLive do
  alias FireSale.Reservations
  use FireSaleWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-bold">Reservations</h1>
    <div class="flex flex-col gap-2 mt-4">
      <.table id="users" rows={@reservations}>
        <:col :let={reservation} label="Product Name"><%= reservation.product.name %></:col>
        <:col :let={reservation} label="Reserved for"><%= reservation.name %></:col>
        <:col :let={reservation} label="Phone"><%= reservation.phone %></:col>
        <:col :let={reservation} label="Email"><%= reservation.email %></:col>
      </.table>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket
    |> mount_reservations()
    |> ok()
  end

  def mount_reservations(socket) do
    r = Reservations.list_confirmed_reservations()

    socket
    |> assign(:reservations, r)
  end
end
