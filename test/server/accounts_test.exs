defmodule Server.AccountsTest do
  use Server.DataCase, async: true

  alias Server.Accounts
  alias Server.Accounts.User
  alias Server.Accounts.Character


  @user_create_attrs %{
    "email" => "shivangs44@gmail.com",
    "password" => "bubbles"
  }

  setup do
    Ecto.Adapters.SQL.Sandbox.allow(Server.Repo, self(), Accounts)
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
    {:ok, %Character{} = warrior} = Accounts.create_character(%{
      "name" => "zhinkk",
      "class" => "warrior",
      "user_id" => context.user.id
    })
    {:ok, %Character{} = mage} = Accounts.create_character(%{
      "name" => "draucia",
      "class" => "mage",
      "user_id" => context.user.id
    })
    %{characters: [archer, warrior, mage]}
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

  describe "when an account has characters" do
    setup [:create_user, :create_characters]
    test "list_characters/1 returns characters for the given user_id", %{user: user, characters: characters} do
      assert Accounts.list_characters(user.id) == characters
    end
  end

  describe "when an account doesn't have characters" do
    setup [:create_user]
    test "list_characters/1 returns an empty array", %{user: user} do
      assert Accounts.list_characters(user.id) == []
    end
  end
end
