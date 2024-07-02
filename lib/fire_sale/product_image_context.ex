defmodule FireSale.ProductImageContext do
  @moduledoc """
  Context manager for image uploads executed by the user
  adding products. Image optimization is done before
  the upload so we have a smaller file size on disk and also
  a thumbnail version of it to show in smaller views.
  """
  alias FireSale.ImageResizer.ResizedImage
  alias FireSale.ImageResizer
  alias FireSale.Storage.FileStore
  alias FireSale.Products.ProductImage
  alias FireSale.Repo
  require Logger

  @spec upload(image_path :: String.t(), product_id :: integer()) ::
          FireSale.result({ProductImage.t(), ProductImage.t()})
  def upload(image_path, product_id) do
    image_path
    |> resize()
    |> upload_to_storage()
    |> store(product_id)
    |> case do
      {:ok, product_image} ->
        {:ok, product_image}

      val ->
        Logger.info("Error: #{inspect(val)}")
        {:error, "Could not upload image"}
    end
  end

  @spec resize(String.t()) :: ResizedImage.t()
  defp resize(image_path) do
    %ResizedImage{} = image = ImageResizer.resize_and_thumb(image_path)
    image
  end

  defp upload_to_storage(%ResizedImage{} = image) do
    result =
      [
        upload_task(image.resized_path, image.resized_filename),
        upload_task(image.thumb_path, image.thumb_filename)
      ]
      |> Task.await_many()

    ImageResizer.clear_resized_image(image)
    {result, image}
  end

  defp upload_task(path, filename) do
    Task.async(fn ->
      FileStore.put_file(path, filename)
    end)
  end

  defp store({[{:ok, _}, {:ok, _}], %ResizedImage{} = image}, product_id) do
    ProductImage.changeset(%ProductImage{}, %{
      name: image.resized_filename,
      product_id: product_id,
      width: image.width,
      height: image.height
    })
    |> Repo.insert()
  end

  defp store({_upload_result, _image}, _product_id),
    do: {:error, "Could not upload images to Storage"}
end
