defmodule FireSale.ProductImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FireSale.ProductImages` context.
  """

  @doc """
  Generate a unique product_image name.
  """
  def unique_product_image_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a product_image.
  """
  def product_image_fixture(attrs \\ %{}) do
    attrs =
      if Map.get(attrs, :product_id) == nil do
        Map.put(attrs, :product_id, FireSale.ProductsFixtures.product_fixture().id)
      else
        attrs
      end

    {:ok, product_image} =
      attrs
      |> Enum.into(%{
        name: unique_product_image_name()
      })
      |> FireSale.ProductImages.create_product_image()

    product_image
  end
end
