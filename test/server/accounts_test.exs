defmodule Server.AccountsTest do
  use Server.DataCase, async: true

  alias Server.Accounts
  alias Server.Accounts.User

  @email "shivangs44@gmail.com"
  @password "bubbles"

  setup do
    Ecto.Adapters.SQL.Sandbox.allow(Server.Repo, self(), Accounts)
    :ok
  end

  describe "when account exists" do
    test "create_user/2 returns an error" do
      {:ok, %User{} = _ } = Accounts.create_user(@email, @password)

      {:error, msg} = Accounts.create_user(@email, @password)
      assert msg == Accounts.email_taken_error()
    end

    test "authenticate/2 returns user when called with valid login" do
      {:ok, %User{} = _} = Accounts.create_user(@email, @password)

      {:ok, user} = Accounts.authenticate(@email, @password)

      query = from u in User, where: u.id == ^user.id
      user_from_db = Server.Repo.one!(query)

      assert user == user_from_db
    end

    test "authenticate/2 returns error when called with invalid logn" do
      {:ok, %User{} = _ } = Accounts.create_user(@email, @password)

      {:error, msg} = Accounts.authenticate(@email, @password <> "_")
      assert msg == Accounts.invalid_password_error()
    end

  end

  describe "when account doesn't exist" do
    test "create_user/2 creates a user" do
      {:ok, %User{} = user} = Accounts.create_user(@email, @password)

      query = from u in User, where: u.id == ^user.id
      user_from_db = Server.Repo.one!(query)

      assert user == user_from_db
    end

    test "authenticate/2 returns an error" do
      {:error, msg} = Accounts.authenticate(@email, @password)
      assert msg == Accounts.account_does_not_exist_error()
    end
  end
end
