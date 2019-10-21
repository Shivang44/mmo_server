defmodule Server.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Server.Accounts.Character

  schema "users" do
    field :access_token, :string
    field :email, :string
    field :password_hash, :string
    has_many :characters, Character

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :access_token])
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email)
  end
end
