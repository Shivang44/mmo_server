defmodule Server.Character.Position do
    use Ecto.Schema
    import Ecto.Changeset
  
    schema "positions" do
      field :x, :float
      field :y, :float
      field :z, :float
      belongs_to :character, Server.Accounts.Character
  
      timestamps()
    end
  
    def changeset(position, attrs) do
      position
      |> cast(attrs, [:x, :y, :z])
      |> validate_required([:x, :y, :z])
    end
  end
  