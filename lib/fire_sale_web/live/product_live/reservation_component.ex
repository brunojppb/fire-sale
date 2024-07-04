defmodule FireSaleWeb.ProductLive.ReservationComponent do
  alias Ecto.Changeset
  alias FireSale.Products.Reservation
  alias FireSale.Reservations
  use FireSaleWeb, :live_component

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Reserve product
        <:subtitle>
          Add your details here. We will send you an email for you to confirm (and avoid bots).<br />
          We will then chat about when you can come and pick this up.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="reservation-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <input type="hidden" name={@form[:product_id].name} value={@product.id} />
        <input
          type="hidden"
          name={@form[:token].name}
          value={Base.url_encode64(:crypto.strong_rand_bytes(32), padding: false)}
        />
        <.input field={@form[:name]} type="text" label="Your name*" data-1p-ignore required />
        <.input field={@form[:email]} type="email" label="Email*" data-1p-ignore required />
        <.input field={@form[:phone]} type="text" label="Phone" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Reserve Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    if product.reserved do
      notify_parent(:redirect)
    end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:reservation, %Reservation{})
     |> assign_new(:form, fn ->
       to_form(Reservations.change_reservation(%Reservation{}))
     end)}
  end

  @impl true
  def handle_event("validate", %{"reservation" => reservation_params}, socket) do
    changeset = Reservations.change_reservation(socket.assigns.reservation, reservation_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"reservation" => params}, socket) do
    reservation_url_fun = fn token -> url(~p"/r/#{token}") end

    case Reservations.reserve_product(socket.assigns.product.id, params, reservation_url_fun) do
      {:ok, _reservation} ->
        notify_parent(:reservation_created)
        {:noreply, socket}

      {:error, %Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}

      {:error, error_message} ->
        {:noreply,
         socket
         |> put_flash(:error, error_message)
         |> redirect(to: ~p"/")}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
