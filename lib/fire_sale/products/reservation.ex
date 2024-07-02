defmodule FireSale.Products.Reservation do
  @moduledoc """
  Reservation created by a given customer.
  Products only go out of the website once they are confirmed
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "reservations" do
    field :name, :string
    # Possible states: "pending" | "confirmed"
    field :status, :string
    field :token, :binary
    field :phone, :string
    field :email, :string
    belongs_to :product, FireSale.Products.Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [:name, :phone, :email, :token, :status, :product_id])
    |> validate_required([:name, :phone, :email, :token, :status, :product_id])
  end
end
