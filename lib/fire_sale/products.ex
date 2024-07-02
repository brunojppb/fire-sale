defmodule FireSale.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias FireSale.Repo

  alias FireSale.Products.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    query = from p in Product, order_by: fragment("? DESC", p.inserted_at), preload: [:user]
    Repo.all(query)
  end

  def list_products_with_images do
    query =
      from p in Product, order_by: fragment("? DESC", p.inserted_at), preload: [:product_images]

    Repo.all(query)
  end

  @doc """
    Get the given product and preload its associated user
  """
  def product_with_user(id) do
    query = from p in Product, where: p.id == ^id, preload: :user
    Repo.one(query)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Gets a single product.

  Returns `nil` if the Product does not exist.
  """
  def get_product(id), do: Repo.get(Product, id)

  def get_product_with_images(id) do
    query = from p in Product, where: p.id == ^id, preload: [:product_images]
    Repo.one(query)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end
