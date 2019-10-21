defmodule Server.Repo.Migrations.AddPositionIdToCharacter do
  use Ecto.Migration

  def change do
    alter table("characters") do
      add :position_id, references("positions")
    end
  end 
end
