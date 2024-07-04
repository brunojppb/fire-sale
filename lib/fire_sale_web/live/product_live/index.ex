defmodule FireSaleWeb.ProductLive.Index do
  alias FireSaleWeb.Endpoint
  use FireSaleWeb, :live_view

  alias FireSale.Products
  alias FireSale.Products.Product

  @products_topic "products"

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, Products.list_products_with_images())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Products.get_product!(id))
  end

  defp apply_action(socket, :add_image, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add images")
    |> assign(:product, Products.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({FireSaleWeb.ProductLive.FormComponent, {:saved, _product}}, socket) do
    Endpoint.broadcast(@products_topic, "product_saved", %{})

    socket
    |> assign(:products, Products.list_products_with_images())
    |> noreply()
  end

  @impl true
  def handle_info({FireSaleWeb.ProductLive.ImageFormComponent, {:saved, _product}}, socket) do
    Endpoint.broadcast(@products_topic, "product_saved", %{})

    socket
    |> assign(:products, Products.list_products_with_images())
    |> noreply()
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    {:noreply, assign(socket, :products, Products.list_products_with_images())}
  end
end
