defmodule Server.Accounts.Character do
  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do
    field :class, :string
    field :name, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :class, :user_id])
    |> validate_required([:name, :class, :user_id])
  end
end
