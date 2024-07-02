defmodule FireSaleWeb.ProductLive.ProductListing do
  alias FireSale.Products.ProductImage
  use FireSaleWeb, :live_view
  alias FireSaleWeb.Endpoint

  alias FireSale.Products

  @products_topic "products"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-gray-100 dark:bg-zinc-800 py-8">
      <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col lg:flex-row -mx-4">
          <div class="md:flex-1 px-4" id="product-gallery">
            <h2 class="text-2xl font-bold text-gray-800 dark:text-white mb-2 block lg:hidden">
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
                >
                  <img
                    class="h-full w-full object-cover object-center lg:h-full lg:w-full"
                    src={~p"/pi/#{Enum.at(@product.product_images, 0).name}"}
                    data-cropped="true"
                    alt={@product.name}
                  />
                </a>
              <% else %>
                <img
                  src={~p"/images/no_img.jpg"}
                  alt={@product.name}
                  class="h-full w-full object-cover object-center lg:h-full lg:w-full"
                />
              <% end %>
            </div>
            <div class="py-4 flex gap-2 flex-wrap">
              <%= for img <- Enum.drop(@product.product_images, 1) do %>
                <div class="group relative">
                  <div class="aspect-square w-20 overflow-hidden rounded-md bg-gray-200 lg:aspect-none group-hover:opacity-75">
                    <a
                      href={~p"/pi/#{img.name}"}
                      data-pswp-width={img.width}
                      data-pswp-height={img.height}
                      target="_blank"
                    >
                      <img
                        src={~p"/pi/#{ProductImage.thumb(img)}"}
                        alt={@product.name}
                        class="h-full w-full object-cover object-center lg:h-full lg:w-full"
                      />
                    </a>
                  </div>
                </div>
              <% end %>
            </div>
            <div class="flex mb-4">
              <div class="px-2 w-full">
                <button class="w-full bg-white text-zinc-700 border-2 dark:-border-2 py-2 px-4 rounded-full font-bold hover:bg-zinc-200 dark:hover:bg-zinc-600 dark:hover:text-white">
                  Reserve product
                </button>
              </div>
            </div>
          </div>
          <div class="md:flex-1 px-4">
            <h2 class="text-2xl font-bold text-gray-800 dark:text-white mb-2">
              <%= @product.name %>
            </h2>
            <div class="flex mb-4">
              <div class="mr-4">
                <span class="font-bold text-gray-700 dark:text-gray-300">Price:</span>
                <span class="text-gray-600 dark:text-gray-300">€ <%= @product.price %></span>
              </div>
              <div>
                <span class="font-bold text-gray-700 dark:text-gray-300">Availability:</span>
                <span class="text-gray-600 dark:text-gray-300">Available to pick-up</span>
              </div>
            </div>

            <div>
              <span class="font-bold text-gray-700 dark:text-gray-300">Description:</span>
              <p class="text-gray-600 dark:text-gray-300 text-sm mt-2">
                <%= @product.description %>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
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

  defp assign_product_or_redirect(socket, product_id) do
    case Products.get_product_with_images(product_id) do
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
