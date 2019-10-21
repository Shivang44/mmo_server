defmodule Server.Repo.Migrations.AddPositionsTable do
  use Ecto.Migration

  def change do
    create table("positions") do
      add :x, :float
      add :y, :float
      add :z, :float

      timestamps()
    end
  end
end
