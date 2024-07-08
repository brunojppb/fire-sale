defmodule FireSale.Repo.Migrations.ChangeProductColumnsToText do
  use Ecto.Migration

  def up do
    alter table(:products) do
      modify :name, :text
      modify :description, :text
    end
  end

  def down do
    alter table(:products) do
      modify :description, :string
      modify :name, :string
    end
  end
end
