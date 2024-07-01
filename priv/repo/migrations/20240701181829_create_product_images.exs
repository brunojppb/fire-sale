defmodule FireSale.Repo.Migrations.CreateProductImages do
  use Ecto.Migration

  def change do
    create table(:product_images) do
      add :name, :string
      add :product_id, references(:products, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:product_images, [:name])
    create index(:product_images, [:product_id])
  end
end
