defmodule Server.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Accounts.User

  schema "characters" do
    field :class, :string
    field :name, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :class, :user_id])
    |> validate_required([:name, :class, :user_id])
    |> unique_constraint(:name)
  end
end
