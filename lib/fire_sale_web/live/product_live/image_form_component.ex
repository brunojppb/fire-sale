defmodule FireSaleWeb.ProductLive.ImageFormComponent do
  use FireSaleWeb, :live_component

  alias FireSale.Products
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Add images to product
        <:subtitle>Add images to product</:subtitle>
      </.header>

      <h2>Upload here...</h2>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
       socket
       |> assign(:uploaded_files, [])
       |> allow_upload(:product_image, accept: ~w(.jpg .jpeg .png), max_entries: 5)}
  end


  @impl true
  def update(%{product: product} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Products.change_product(product))
     end)}
  end

end
