defmodule FireSale.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FireSale.Products` context.
  """

  import FireSale.AccountsFixtures

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    attrs =
      if Map.get(attrs, :user_id) == nil do
        Map.put(attrs, :user_id, user_fixture().id)
      else
        attrs
      end

    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "Product #{System.unique_integer()}",
        price: "120.5",
        published: false,
        reserved: false,
        tags: "option1,option2"
      })
      |> FireSale.Products.create_product()

    product
  end
end
