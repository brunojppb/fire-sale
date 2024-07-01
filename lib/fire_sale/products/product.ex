defmodule FireSale.Products.Product do
  @moduledoc """
  Products being solve during the file sale
  """
  alias FireSale.Products.Tag
  alias FireSale.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :tags, Tag
    belongs_to :user, User
    has_many :product_images, FireSale.Products.ProductImage

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :user_id, :tags])
    |> validate_required([:name, :description, :price, :tags, :user_id])
    |> unique_constraint(:name)
  end
end
