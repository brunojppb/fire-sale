defmodule FireSaleWeb.HomeLive do
  alias FireSaleWeb.Endpoint
  use FireSaleWeb, :live_view

  alias FireSale.Products

  @products_topic "products"

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl px-4 py-16 sm:px-6 sm:py-24 lg:max-w-7xl lg:px-8">
      <h2 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-zinc-50">
        Available Items
      </h2>

      <div class="mt-6 grid grid-cols-2 gap-x-6 gap-y-10 md:grid-cols-3 lg:grid-cols-4 xl:gap-x-8">
        <%= for product <- @products do %>
          <div class="group relative">
            <div class="aspect-h-1 aspect-w-1 w-full overflow-hidden rounded-md bg-gray-200 lg:aspect-none group-hover:opacity-75 lg:h-80">
              <img
                src="https://tailwindui.com/img/ecommerce-images/product-page-01-related-product-01.jpg"
                alt="Front of men&#039;s Basic Tee in black."
                class="h-full w-full object-cover object-center lg:h-full lg:w-full"
              />
            </div>
            <div class="mt-4 flex flex-col justify-between">
              <div>
                <h3 class="text-sm text-gray-700">
                  <a href="#" class="dark:text-zinc-50">
                    <span aria-hidden="true" class="absolute inset-0"></span>
                    <span class="dark:text-zinc-50"><%= product.name %></span>
                  </a>
                </h3>
                <p class="text-sm font-medium text-gray-900 dark:text-zinc-50 font-bold">
                  € <%= product.price %>
                </p>
                <p class="mt-1 text-sm text-gray-500 dark:text-gray-300">
                  <%= product.description %>
                </p>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@products_topic)
    end

    socket
    |> assign_products()
    |> ok()
  end

  def handle_info(%{event: "product_saved"}, socket) do
    socket
    |> assign_products()
    |> noreply()
  end

  defp assign_products(socket) do
    products = Products.list_products()

    socket
    |> assign(products: products)
  end
end
