defmodule Server.AccountsTest do
  use Server.DataCase, async: true

  alias Server.Accounts
  alias Server.Accounts.User
  alias Server.Accounts.Character

  @user_create_attrs %{
    "email" => "shivangs44@gmail.com",
    "password" => "bubbles"
  }

  @character_create_attrs %{
    "name" => "shivang",
    "class" => "archer"
  }

  setup do
    Ecto.Adapters.SQL.Sandbox.allow(Server.Repo, self(), Accounts)
    :ok
  end

  defp create_user(_context) do
    {:ok, %User{} = user} = Accounts.create_user(@user_create_attrs)
    %{user: user}
  end

  defp create_character(_context) do
    {:ok, %Character{} = character} = Accounts.create_character(a)
  end

  describe "when account exists" do
    setup [:create_user]

    test "create_user/2 returns an error" do
      {:error, msg} = Accounts.create_user(@user_create_attrs)
      assert msg == Accounts.email_taken_error()
    end

    test "authenticate/2 returns user when valid login" do
      {:ok, user} = Accounts.authenticate(@user_create_attrs)

      query = from u in User, where: u.id == ^user.id
      user_from_db = Server.Repo.one!(query)

      assert user == user_from_db
    end

    test "authenticate/2 returns error when invalid logn" do
      {:error, msg} = Accounts.authenticate(Map.replace!(@user_create_attrs, "password", @user_create_attrs["password"] <> "_"))
      assert msg == Accounts.invalid_password_error()
    end

  end

  describe "when account doesn't exist" do
    test "create_user/2 creates a user" do
      {:ok, %User{} = user} = Accounts.create_user(@user_create_attrs)

      query = from u in User, where: u.id == ^user.id
      user_from_db = Server.Repo.one!(query)

      assert user == user_from_db
    end

    test "authenticate/2 returns an error" do
      {:error, msg} = Accounts.authenticate(@user_create_attrs)
      assert msg == Accounts.account_does_not_exist_error()
    end
  end

  # describe "when an account exists and has characters" do
  #   setup [:create_user, :create_character]
  # end



  # describe "characters" do
  #   alias Server.Accounts.Character

  #   @valid_attrs %{class: "some class", name: "some name", user_id: 42}
  #   @update_attrs %{class: "some updated class", name: "some updated name", user_id: 43}
  #   @invalid_attrs %{class: nil, name: nil, user_id: nil}

  #   def character_fixture(attrs \\ %{}) do
  #     {:ok, character} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Accounts.create_character()

  #     character
  #   end

  #   test "list_characters/0 returns all characters" do
  #     character = character_fixture()
  #     assert Accounts.list_characters() == [character]
  #   end

  #   test "get_character!/1 returns the character with given id" do
  #     character = character_fixture()
  #     assert Accounts.get_character!(character.id) == character
  #   end

  #   test "create_character/1 with valid data creates a character" do
  #     assert {:ok, %Character{} = character} = Accounts.create_character(@valid_attrs)
  #     assert character.class == "some class"
  #     assert character.name == "some name"
  #     assert character.user_id == 42
  #   end

  #   test "create_character/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Accounts.create_character(@invalid_attrs)
  #   end

  #   test "update_character/2 with valid data updates the character" do
  #     character = character_fixture()
  #     assert {:ok, %Character{} = character} = Accounts.update_character(character, @update_attrs)
  #     assert character.class == "some updated class"
  #     assert character.name == "some updated name"
  #     assert character.user_id == 43
  #   end

  #   test "update_character/2 with invalid data returns error changeset" do
  #     character = character_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Accounts.update_character(character, @invalid_attrs)
  #     assert character == Accounts.get_character!(character.id)
  #   end

  #   test "delete_character/1 deletes the character" do
  #     character = character_fixture()
  #     assert {:ok, %Character{}} = Accounts.delete_character(character)
  #     assert_raise Ecto.NoResultsError, fn -> Accounts.get_character!(character.id) end
  #   end

  #   test "change_character/1 returns a character changeset" do
  #     character = character_fixture()
  #     assert %Ecto.Changeset{} = Accounts.change_character(character)
  #   end
  # end
end
