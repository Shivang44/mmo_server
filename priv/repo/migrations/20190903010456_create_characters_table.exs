defmodule Server.Repo.Migrations.CreateCharactersTable do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
      add :class, :string
      add :user_id, references("users")

      timestamps()
    end

    create unique_index(:characters, [:name])

  end
end
