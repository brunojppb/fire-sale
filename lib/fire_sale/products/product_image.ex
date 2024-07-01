defmodule FireSale.ProductImage do
  @moduledoc """
  Images associated with products
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_images" do
    field :name, :string
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product_image, attrs) do
    product_image
    |> cast(attrs, [:name, :product_id])
    |> validate_required([:name, :product_id])
    |> unique_constraint(:name)
  end
end
