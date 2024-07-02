defmodule FireSale.Products.Product do
  @moduledoc """
  Products being solve during the file sale
  """
  alias FireSale.Products.Tag
  alias FireSale.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t(),
          price: number(),
          user: FireSale.Accounts.User.t() | Ecto.Association.NotLoaded.t(),
          tags: list(FireSale.Products.Tag.t()) | Ecto.Association.NotLoaded.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

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
