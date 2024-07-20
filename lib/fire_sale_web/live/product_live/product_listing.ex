defmodule FireSaleWeb.ProductLive.ProductListing do
  alias FireSale.Products.ProductImage
  use FireSaleWeb, :live_view
  alias FireSaleWeb.Endpoint

  alias FireSale.Products

  @products_topic "products"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-8 bg-gray-100 dark:bg-zinc-800">
      <div class="max-w-6xl px-4 mx-auto sm:px-6 lg:px-8">
        <div class="flex flex-col -mx-4 lg:flex-row">
          <div class="px-4 md:flex-1" id="product-gallery">
            <h2 class={[
              "text-2xl font-bold text-gray-800 dark:text-white mb-2 block lg:hidden",
              @current_user && !@product.published && "border border-rose-500 p-2 border-dashed"
            ]}>
              <%= @product.name %>
            </h2>
            <div class="h-[460px] rounded-lg bg-gray-300 dark:bg-gray-700">
              <%= if length(@product.product_images) > 0 do %>
                <a
                  href={~p"/pi/#{Enum.at(@product.product_images, 0).name}"}
                  data-pswp-width={"#{Enum.at(@product.product_images, 0).width}"}
                  data-pswp-height={"#{Enum.at(@product.product_images, 0).height}"}
                  data-cropped="true"
                  target="_blank"
                  class="gallery-item"
                >
                  <img
                    class="object-cover object-center w-full h-full lg:h-full lg:w-full"
                    src={~p"/pi/#{Enum.at(@product.product_images, 0).name}"}
                    data-cropped="true"
                    alt={@product.name}
                  />
                </a>
              <% else %>
                <img
                  src={~p"/images/no_img.jpg"}
                  alt={@product.name}
                  class="object-cover object-center w-full h-full lg:h-full lg:w-full"
                />
              <% end %>
            </div>
            <div class="flex flex-wrap gap-2 py-4">
              <%= for img <- Enum.drop(@product.product_images, 1) do %>
                <div class="relative group">
                  <div class="w-20 overflow-hidden bg-gray-200 rounded-md aspect-square lg:aspect-none group-hover:opacity-75">
                    <a
                      href={~p"/pi/#{img.name}"}
                      data-pswp-width={img.width}
                      data-pswp-height={img.height}
                      class="gallery-item"
                      target="_blank"
                    >
                      <img
                        src={~p"/pi/#{ProductImage.thumb(img)}"}
                        alt={@product.name}
                        class="object-cover object-center w-full h-full lg:h-full lg:w-full"
                      />
                    </a>
                  </div>
                </div>
              <% end %>
            </div>
            <div class="flex mb-4">
              <div class="w-full px-2">
                <.button disabled={@product.reserved} phx-click="go_to_reservation">
                  <%= if @product.reserved do %>
                    Not available.
                  <% else %>
                    Reserve product
                  <% end %>
                </.button>
                <%= if @current_user do %>
                  <.link href={~p"/ops/products/#{@product.id}/edit"}>Admin edit</.link>
                <% end %>
              </div>
            </div>
          </div>
          <div class="px-4 md:flex-1">
            <h2 class={[
              "text-2xl font-bold text-gray-800 dark:text-white mb-2",
              @current_user && !@product.published && "border border-rose-500 p-2 border-dashed",
              @product.reserved && "line-through"
            ]}>
              <%= @product.name %>
            </h2>
            <div class="flex flex-col gap-4 mb-4 lg:gap-8">
              <div class="mr-4">
                <span class={[
                  "text-3xl font-bold text-gray-900 dark:text-white",
                  @product.reserved && "line-through"
                ]}>
                  <%= if Decimal.compare(@product.price, 0) == :gt do %>
                    € <%= @product.price %>
                  <% else %>
                    FREE
                  <% end %>
                </span>
              </div>
              <div>
                <span class="font-bold text-gray-700 dark:text-gray-300">Availability:</span>
                <%= if @product.reserved do %>
                  <span class="text-gray-600 dark:text-gray-300">Reserved</span>
                <% else %>
                  <span class="text-gray-600 dark:text-gray-300">Available to pick-up</span>
                <% end %>
              </div>
            </div>

            <div>
              <span class="font-bold text-gray-700 dark:text-gray-300">Description:</span>
              <p class="mt-2 text-sm text-gray-600 whitespace-pre-line dark:text-gray-300">
                <%= @product.description %>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <.modal
      :if={@live_action in [:reserve]}
      id="reserve-product-modal"
      show
      on_cancel={JS.patch(~p"/p/#{@product}")}
    >
      <.live_component
        module={FireSaleWeb.ProductLive.ReservationComponent}
        id={@product.id}
        action={@live_action}
        product={@product}
        patch={~p"/p/#{@product}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@products_topic)
      {:ok, push_event(socket, "gallery", %{})}
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_event("go_to_reservation", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/p/#{socket.assigns.product}/r")}
  end

  @impl true
  def handle_params(%{"id" => product_id}, _, socket) do
    socket
    |> assign_product_or_redirect(product_id)
    |> noreply()
  end

  @impl true
  def handle_info(%{event: "product_saved"}, socket) do
    socket
    |> assign_product_or_redirect(socket.assigns.product.id)
    |> noreply()
  end

  @impl true
  def handle_info({FireSaleWeb.ProductLive.ReservationComponent, :redirect}, socket) do
    socket
    |> put_flash(:error, "Sorry, this product has been reserved to someone else")
    |> redirect(to: ~p"/")
    |> noreply()
  end

  @impl true
  def handle_info({FireSaleWeb.ProductLive.ReservationComponent, :reservation_created}, socket) do
    socket
    |> redirect(to: ~p"/r/s/thx")
    |> noreply()
  end

  defp assign_product_or_redirect(socket, product_id) do
    product_fetch_fn =
      if socket.assigns[:current_user] do
        &Products.get_product_with_images/1
      else
        &Products.get_published_product/1
      end

    case product_fetch_fn.(product_id) do
      nil ->
        socket
        |> put_flash(:error, "Product with id '#{product_id}' not found")
        |> redirect(to: ~p"/")

      product ->
        socket
        |> assign(:page_title, product.name)
        |> assign(:product, product)
    end
  end
end
