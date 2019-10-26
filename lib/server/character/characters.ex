defmodule Server.Characters do
    import Ecto.Query

    alias Server.Accounts.Character
    alias Server.Repo

    def validate_movement(%{character_id: _character_id, x: _x, y: _y, z: _z}) do
        true
    end

    def update_position(%{character_id: character_id, x: x, y: y, z: z}) do
        from(c in Character, where: c.id == ^character_id)
        |> Repo.update_all(set: [x: x], set: [y: y], set: [z: z])
    end

end
