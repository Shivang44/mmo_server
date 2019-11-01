defmodule Server.CharactersTest do
    use Server.DataCase, async: true

    alias Server.Accounts
    alias Server.Accounts.User
    alias Server.Accounts.Character
    alias Server.Characters
  
    @user_create_attrs %{
      "email" => "shivangs44@gmail.com",
      "password" => "bubbles"
    }
  
    setup do
      Ecto.Adapters.SQL.Sandbox.allow(Server.Repo, self(), Characters)
      :ok
    end
  
    defp create_user(_context) do
      {:ok, %User{} = user} = Accounts.create_user(@user_create_attrs)
      %{user: user}
    end
  
    defp create_characters(context) do
      {:ok, %Character{} = archer} = Accounts.create_character(%{
        "name" => "shivang",
        "class" => "archer",
        "user_id" => context.user.id
      })
      %{character: archer}
    end

    describe "when a character exists" do
        setup [:create_user, :create_characters]

        test "update_position updates a characters position", %{user: _, character: character} do
            x_expected = 1.0
            y_expected = 2.0
            z_expected = 3.0
            Characters.update_position(%{character_id: character.id, x: x_expected, y: y_expected, z: z_expected})
            
            query = from c in Character, where: c.id == ^character.id
            character_from_db = Server.Repo.one!(query)

            assert character_from_db.x == x_expected
            assert character_from_db.y == y_expected
            assert character_from_db.z == z_expected
        end
    end

end