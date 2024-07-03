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
    |> validate_required([:name, :email, :token, :status, :product_id])
    |> validate_email()
    |> validate_length(:name, max: 100)
    |> validate_length(:phone, max: 100)
    |> unique_constraint([:email, :product_id],
      message: "You've already reserved this product. Please check your email."
    )
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end
end
