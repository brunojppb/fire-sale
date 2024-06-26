defmodule FireSaleWeb.ThemeToggleLive do
  use FireSaleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <button type="button" phx-click={JS.dispatch("fire_sale:toggle_theme")}>
      <img src={~p"/images/sun.svg"} class="h-auto w-8 rounded-full hidden dark:block" alt="Toggle" />
      <img src={~p"/images/moon.svg"} class="h-auto w-8 rounded-full block dark:hidden" alt="Toggle" />
      <span class="sr-only">Toggle theme </span>
    </button>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # Make sure that theme toggle does not render the entire layout all over again
    socket = assign(socket, :value, "dark")
    {:ok, socket, layout: false}
  end
end
