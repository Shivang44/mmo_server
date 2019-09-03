defmodule Server.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
      add :class, :string
      add :user_id, :integer

      timestamps()
    end

  end
end
