defmodule Server.AccountsTest do
  use Server.DataCase, async: true

  alias Server.Accounts
  alias Server.Accounts.User

  @email "shivangs44@gmail.com"
  @password "bubbles"


  def user_fixture() do
    {:ok, user} = Accounts.create_user(@email, @password)
    user
  end

  setup do
    Ecto.Adapters.SQL.Sandbox.allow(Server.Repo, self(), Accounts)
    {:ok, %User{} = user} = Accounts.create_user(@email, @password)
    %{user: user}
  end

  describe "list_user/0" do
    test "list_users/0 returns all users", context do
      assert Accounts.list_users() == [context[:user]]
    end
  end

  describe "create_user/2 when email is available" do
    test "create_user/2 creates a user", context do
      user = context[:user]
      assert user.email == @email
      assert user.password_hash

      query = from u in User, where: u.id == ^user.id
      assert Server.Repo.exists?(query)
    end
  end

  describe "create_user/2 when email is taken" do
    test "it returns an error", context do
      assert {:error, msg} = Accounts.create_user(@email, @password)
      assert msg == Accounts.email_taken_error()
    end
  end

  describe "authenticate/2 when email and password is correct" do
    test "it authenticates and returns an access token" do
      assert {:ok, access_token} = Accounts.authenticate(@email, @password)
    end
  end

  describe "authenticate/2 when email and password is incorrect" do
    test "it returns an invalid password error" do
      assert {:error, msg} = Accounts.authenticate(@email, @password <> "err")
      assert msg == Accounts.invalid_password_error()
    end
  end

  describe "authenticate/2 when email doesn't exist" do
    test "it returns an Account does not exist error" do
      assert {:error, msg} = Accounts.authenticate(@email <> "err", @password)
      assert msg == Accounts.account_does_not_exist_error()
    end
  end
end
