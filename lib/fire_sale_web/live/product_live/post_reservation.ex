defmodule FireSaleWeb.ProductLive.PostReservation do
  use FireSaleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-center my-10">
      <div>
        <div class="flex flex-col items-center space-y-2">
          <.email_icon />
          <h1 class="text-4xl font-bold">Now, check your email</h1>
          <p class="text-center">
            To avoid bots, we require you to confirm your reservation via the link we've just sent you.
            <br /> Cheers! <br /> Bruno & Rhaisa
          </p>
          <div class="flex gap-2">
            <img
              src={~p"/images/bruno.jpeg"}
              class="h-auto w-12 rounded-full ring-2 p-1 ring-gray-300 dark:ring-gray-500"
              alt="Bruno"
            />
            <img
              src={~p"/images/rha.jpeg"}
              class="h-auto w-12 rounded-full p-1 ring-2 ring-gray-300 dark:ring-gray-500"
              alt="Rhaisa"
            />
          </div>
          <.link
            href={~p"/"}
            class="inline-flex items-center rounded border border-indigo-600 bg-indigo-600 px-4 py-2 text-white hover:bg-indigo-700 focus:outline-none focus:ring"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="mr-2 h-3 w-3"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M7 16l-4-4m0 0l4-4m-4 4h18" />
            </svg>
            <span class="text-sm font-medium"> Home </span>
          </.link>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
