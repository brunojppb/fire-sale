defmodule FireSaleWeb.ProductLive.ProductListing do
  use FireSaleWeb, :live_view

  alias FireSale.Products

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-gray-100 dark:bg-zinc-800 py-8">
      <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col lg:flex-row -mx-4">
          <div class="md:flex-1 px-4">
            <div class="h-[460px] rounded-lg bg-gray-300 dark:bg-gray-700 mb-4">
              <img
                class="h-full w-full object-cover object-center lg:h-full lg:w-full"
                src="https://tailwindui.com/img/ecommerce-images/product-page-01-related-product-01.jpg"
                alt={@product.name}
              />
            </div>
            <div class="flex -mx-2 mb-4">
              <div class="w-1/2 px-2">
                <button class="w-full bg-gray-900 dark:bg-gray-600 text-white py-2 px-4 rounded-full font-bold hover:bg-gray-800 dark:hover:bg-gray-700">
                  Add to Cart
                </button>
              </div>
              <div class="w-1/2 px-2">
                <button class="w-full bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-white py-2 px-4 rounded-full font-bold hover:bg-gray-300 dark:hover:bg-gray-600">
                  Add to Wishlist
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
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    case Products.get_product(id) do
      nil ->
        socket
        |> put_flash(:error, "Product with id #{id} not found")
        |> redirect(to: ~p"/")
        |> noreply()

      product ->
        socket
        |> assign(:page_title, product.name)
        |> assign(:product, product)
        |> noreply()
    end
  end
end
