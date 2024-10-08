defmodule FireSaleWeb.ProductLive.ImageFormComponent do
  alias FireSale.Products.ProductImage
  alias FireSale.ProductImages
  use FireSaleWeb, :live_component

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Add images to product
        <:subtitle>Add images to product</:subtitle>
      </.header>

      <div>
        <form id="upload-form" phx-submit="save" phx-change="validate" phx-target={@myself}>
          <div class="grid md:grid-cols-2 md:gap-6">
            <.live_file_input upload={@uploads.product_image} />
            <.button type="submit">Upload</.button>
          </div>
        </form>

        <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
          <%= for entry <- @uploads.product_image.entries do %>
            <div>
              <figure>
                <.live_img_preview entry={entry} class="h-auto max-w-full rounded-lg" />
                <figcaption><%= entry.client_name %></figcaption>
              </figure>
              <article class="upload-entry">
                <%!-- entry.progress will update automatically for in-flight entries --%>
                <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>

                <%!-- Phoenix.Component.upload_errors/2 returns a list of error atoms --%>
                <%= for err <- upload_errors(@uploads.product_image, entry) do %>
                  <p class="alert alert-danger"><%= error_to_string(err) %></p>
                <% end %>
              </article>
            </div>
          <% end %>
        </div>

        <%!-- Uploaded images  --%>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-8">
          <%= for img <- @product_images do %>
            <div>
              <div>
                <img
                  class="h-auto max-w-full rounded-lg"
                  src={~p"/pi/#{ProductImage.thumb(img)}"}
                  alt=""
                />
              </div>
              <.link
                phx-click={JS.push("delete", value: %{product_image_id: img.id})}
                phx-target={@myself}
                data-confirm="Are you sure?"
              >
                <.icon name="hero-trash" class="ml-1 h-4 w-4" />
                <span class="sr-only">Delete</span>
              </.link>
            </div>
          <% end %>
        </div>
      </div>
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
     |> assign_product_images(product)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"product_image_id" => id} = _params, socket) do
    img = ProductImages.get_product_image!(id)
    {:ok, _} = ProductImages.delete_product_image(img)

    {:noreply,
     socket
     |> assign_product_images(socket.assigns.product)}
  end

  @impl true
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :product_image, fn %{path: path}, _entry ->
        {:ok, product_image} =
          FireSale.ProductImageContext.upload(path, socket.assigns.product.id)

        {:ok, ~p"/pi/#{product_image.id}"}
      end)

    # Notify active clients about the new image uploads
    notify_parent({:saved, socket.assigns.product})

    socket =
      socket
      |> assign_product_images(socket.assigns.product)
      |> update(:uploaded_files, &(&1 ++ uploaded_files))

    {:noreply, socket}
  end

  defp assign_product_images(socket, product) do
    product_images = FireSale.ProductImages.get_product_images(product.id)

    socket
    |> assign(:product_images, product_images)
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
