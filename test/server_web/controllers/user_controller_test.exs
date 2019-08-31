defmodule ServerWeb.UserControllerTest do
  use ServerWeb.ConnCase, async: true
  require IEx

  alias Server.Accounts
  alias Server.Accounts.User

  @email "shivangs44@gmail.com"
  @password "bubbles"

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.allow(Server.Repo, self(), Accounts)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "creates user when email is available", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :create), %{"email" => @email, "password" => @password})
        |> json_response(201)

      response_data = response["data"]

      query = from u in User, where: u.id == ^response_data["id"]
      user_from_db = Server.Repo.one!(query)

      assert response_data["id"] == user_from_db.id
      assert response_data["access_token"] == user_from_db.access_token
      assert response_data["email"] == user_from_db.email
      assert response_data["password_hash"] == user_from_db.password_hash
    end

    test "returns error when email is unavailable", %{conn: conn} do
      {:ok, %User{} = _} = Accounts.create_user(@email, @password)

      response =
        conn
        |> post(Routes.user_path(conn, :create), %{"email" => @email, "password" => @password})
        |> json_response(422)

      assert response["error"] == Accounts.email_taken_error()
    end
  end

  describe "login when account doesn't exist" do
    test "it returns an account doesn't exist error", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :login), %{"email" => @email, "password" => @password})
        |> json_response(422)

      assert response["error"] == Accounts.account_does_not_exist_error()
    end
  end

  describe "login when account exists" do
    test "it returns access_token with a valid login", %{conn: conn} do
      {:ok, %User{} = _} = Accounts.create_user(@email, @password)

      response =
        conn
        |> post(Routes.user_path(conn, :login), %{"email" => @email, "password" => @password})
        |> json_response(202)

      response_data = response["data"]

      query = from u in User, where: u.id == ^response_data["id"]
      user_from_db = Server.Repo.one!(query)

      assert response_data["access_token"] == user_from_db.access_token
    end

    test "it returns an invalid password error when invalid login", %{conn: conn} do
      {:ok, %User{} = _} = Accounts.create_user(@email, @password)

      response =
        conn
        |> post(Routes.user_path(conn, :login), %{"email" => @email, "password" => @password <> "_"})
        |> json_response(422)

      assert response["error"] == Accounts.invalid_password_error()
    end
  end
end
