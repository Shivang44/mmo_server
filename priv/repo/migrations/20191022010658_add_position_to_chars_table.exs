defmodule Server.Repo.Migrations.AddPositionToCharsTable do
  use Ecto.Migration

  def change do
    alter table("characters") do
      add :x, :float, default: 0, null: false
      add :y, :float, default: 0, null: false
      add :z, :float, default: 0, null: false
    end
  end
end
