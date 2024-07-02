defmodule FireSaleWeb.ProductLive.ReservationComponent do
  use FireSaleWeb, :live_component

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Reserve product
        <:subtitle>Add your details. Bruno and Rhaisa will reach out to you.</:subtitle>
      </.header>

      <div>
        Something here
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  # defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
