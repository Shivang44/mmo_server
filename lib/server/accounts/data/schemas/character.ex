defmodule Server.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Accounts.User

  schema "characters" do
    field :class, :string
    field :name, :string
    field :x, :float, default: 0.0
    field :y, :float, default: 0.0
    field :z, :float, default: 0.0
    
    belongs_to :user, User

    timestamps()
  end

  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :class, :user_id, :x, :y, :z])
    |> validate_required([:name, :class, :user_id])
    |> unique_constraint(:name)
  end
end
