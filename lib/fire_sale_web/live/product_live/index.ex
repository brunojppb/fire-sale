defmodule FireSaleWeb.ProductLive.Index do
  alias FireSaleWeb.Endpoint
  use FireSaleWeb, :live_view

  alias FireSale.Products
  alias FireSale.Products.Product

  @products_topic "products"

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign_products()
    |> ok()
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
    |> assign_products()
    |> noreply()
  end

  @impl true
  def handle_info({FireSaleWeb.ProductLive.ImageFormComponent, {:saved, _product}}, socket) do
    Endpoint.broadcast(@products_topic, "product_saved", %{})

    socket
    |> assign_products()
    |> noreply()
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    socket
    |> assign_products()
    |> noreply()
  end

  defp assign_products(socket) do
    products = Products.list_admin_products()

    socket
    |> assign(:products, products)
    |> assign_totals()
  end

  defp assign_totals(socket) do
    {total, reserved} =
      socket.assigns.products
      |> Enum.reduce({Decimal.new(0), Decimal.new(0)}, fn product, {total, reserved} ->
        {
          Decimal.add(total, product.price),
          Decimal.add(reserved, if(product.reserved, do: product.price, else: Decimal.new(0)))
        }
      end)

    socket
    |> assign(:total, total)
    |> assign(:reserved, reserved)
  end
end
