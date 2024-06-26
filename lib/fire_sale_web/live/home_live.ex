defmodule FireSaleWeb.HomeLive do
  alias FireSaleWeb.Endpoint
  use FireSaleWeb, :live_view

  alias FireSale.Products

  @products_topic "products"

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl px-4 py-4 md:py-8 sm:px-6 lg:max-w-7xl lg:px-8">
      <div class="flex flex-col gap-4">
        <h1 class="text-2xl md:text-4xl font-bold tracking-tight text-gray-900 dark:text-zinc-50">
          Hi there <span role="img" aria-label="hand waving">👋</span>
        </h1>
        <div class="flex gap-2">
          <img
            src={~p"/images/bruno.jpeg"}
            class="h-auto w-12 lg:w-16 rounded-full ring-2 p-1 ring-gray-300 dark:ring-gray-500"
            alt="Bruno"
          />
          <img
            src={~p"/images/rha.jpeg"}
            class="h-auto w-12 lg:w-16 rounded-full p-1 ring-2 ring-gray-300 dark:ring-gray-500"
            alt="Rhaisa"
          />
        </div>
        <p>
          <strong>Bruno</strong>
          and <strong>Rhaisa</strong>
          here.<br /> We've been living in Vienna <span role="img" aria-label="Austrian flag">🇦🇹</span>
          for the past 8 years, but now we are moving to Spain <span
            role="img"
            aria-label="Spanish flag"
          >🇪🇸</span>,
          so we built this website to make it easier to sell all of our stuff before we go.
        </p>
        <p>
          Buying our stuff is super easy:
          <ul class="space-y-1 text-gray-500 list-disc list-inside dark:text-gray-400">
            <li>Check the products down below</li>
            <li>If you like it, hit <strong>reserve product</strong></li>
            <li>Enter your email and phone number</li>
            <li>
              You won't have to pay anything in here, but we will figure out the details between us via email or phone
            </li>
            <li>
              We will schedule for your to come and pick it up.
            </li>
          </ul>
        </p>
      </div>

      <h2 class="text-2xl font-bold tracking-tight text-gray-900 dark:text-zinc-50 mt-4">
        Available Items
      </h2>

      <div class="mt-6 grid grid-cols-2 gap-x-6 gap-y-10 md:grid-cols-3 lg:grid-cols-4 xl:gap-x-8">
        <%= for product <- @products do %>
          <div class="group relative">
            <div class="aspect-h-1 aspect-w-1 w-full overflow-hidden rounded-md bg-gray-200 lg:aspect-none group-hover:opacity-75 lg:h-80">
              <img
                src="https://tailwindui.com/img/ecommerce-images/product-page-01-related-product-01.jpg"
                alt={product.name}
                class="h-full w-full object-cover object-center lg:h-full lg:w-full"
              />
            </div>
            <div class="mt-4 flex flex-col justify-between">
              <div>
                <h3 class="text-sm text-gray-700">
                  <.link href={~p"/p/#{product.id}"} class="dark:text-zinc-50">
                    <span aria-hidden="true" class="absolute inset-0"></span>
                    <span class="dark:text-zinc-50"><%= product.name %></span>
                  </.link>
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
