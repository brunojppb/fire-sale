defmodule FireSale.Products.Product do
  @moduledoc """
  Products being solve during the file sale
  """
  alias FireSale.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :tags, {:array, :string}
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :tags, :user_id])
    |> validate_required([:name, :description, :price, :tags, :user_id])
    |> unique_constraint(:user_id)
  end
end
