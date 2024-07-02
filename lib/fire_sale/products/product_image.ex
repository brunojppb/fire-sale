defmodule FireSale.Products.ProductImage do
  @moduledoc """
  Images associated with products
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          product_id: integer(),
          product: FireSale.Products.Product.t() | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "product_images" do
    field :name, :string
    belongs_to :product, FireSale.Products.Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product_image, attrs) do
    product_image
    |> cast(attrs, [:name, :product_id])
    |> validate_required([:name, :product_id])
    |> unique_constraint(:name)
  end

  def thumb(%__MODULE__{} = product_image) do
    "thumb_#{product_image.name}"
  end
end
