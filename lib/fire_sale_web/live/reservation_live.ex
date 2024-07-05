defmodule FireSaleWeb.ReservationLive do
  use FireSaleWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl px-4 py-4 md:py-8 sm:px-6 lg:max-w-7xl lg:px-8">
      <div class="flex flex-col gap-4">
        <h1 class="text-2xl md:text-4xl font-bold tracking-tight text-gray-900 dark:text-zinc-50">
          Reservations
        </h1>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket
    |> assign_reservations()
    |> ok()
  end

  defp assign_reservations(socket) do
    reservations = FireSale.Reservations.list_reservations()
    assign(socket, :reservations, reservations)
  end
end
