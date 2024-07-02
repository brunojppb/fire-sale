defmodule FireSale.ProductImages do
  @moduledoc """
  The ProductImages context.
  """

  import Ecto.Query, warn: false
  alias FireSale.Repo

  alias FireSale.Products.ProductImage

  @doc """
  Returns the list of product_images.

  ## Examples

      iex> list_product_images()
      [%ProductImage{}, ...]

  """
  def list_product_images do
    Repo.all(ProductImage)
  end

  def get_product_images(product_id) do
    query = from pi in ProductImage, where: pi.product_id == ^product_id
    Repo.all(query)
  end

  @doc """
  Gets a single product_image.

  Raises `Ecto.NoResultsError` if the Product image does not exist.

  ## Examples

      iex> get_product_image!(123)
      %ProductImage{}

      iex> get_product_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_image!(id), do: Repo.get!(ProductImage, id)

  @doc """
  Creates a product_image.

  ## Examples

      iex> create_product_image(%{field: value})
      {:ok, %ProductImage{}}

      iex> create_product_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_image(attrs \\ %{}) do
    %ProductImage{}
    |> ProductImage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_image.

  ## Examples

      iex> update_product_image(product_image, %{field: new_value})
      {:ok, %ProductImage{}}

      iex> update_product_image(product_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_image(%ProductImage{} = product_image, attrs) do
    product_image
    |> ProductImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_image.

  ## Examples

      iex> delete_product_image(product_image)
      {:ok, %ProductImage{}}

      iex> delete_product_image(product_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_image(%ProductImage{} = product_image) do
    Repo.delete(product_image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_image changes.

  ## Examples

      iex> change_product_image(product_image)
      %Ecto.Changeset{data: %ProductImage{}}

  """
  def change_product_image(%ProductImage{} = product_image, attrs \\ %{}) do
    ProductImage.changeset(product_image, attrs)
  end
end
