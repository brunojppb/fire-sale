defmodule FireSale.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :name, :string, null: false
      add :phone, :string, null: false
      add :email, :string, null: false
      add :token, :binary, null: false
      add :status, :string, null: false, default: "pending"
      add :product_id, references(:products, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:reservations, [:product_id])
    create index(:reservations, [:status])
    create index(:reservations, [:token])
  end
end
