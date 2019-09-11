defmodule ServerWeb.UserControllerTest do
  use ServerWeb.ConnCase, async: true
  require IEx

  alias Server.Accounts
  alias Server.Accounts.User

  @create_attrs %{
    "email" => "shivangs44@gmail.com",
    "password" => "bubbles"
  }

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.allow(Server.Repo, self(), Accounts)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp create_user(_context) do
    {:ok, %User{} = user} = Accounts.create_user(@create_attrs)
    %{user: user}
  end

  describe "when account exists" do
    setup [:create_user]

    test ":create returns an email taken error", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :create), @create_attrs)
        |> json_response(422)

      assert response["error"] == Accounts.email_taken_error()
    end

    test ":login sets access_token and returns updated user when given valid credentials", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :login), @create_attrs)
        |> json_response(202)

      response_data = response["data"]

      query = from u in User, where: u.id == ^response_data["id"]
      user_from_db = Server.Repo.one!(query)

      assert response_data["access_token"] == user_from_db.access_token
      assert response_data["email"] == user_from_db.email
      assert response_data["password_hash"] == user_from_db.password_hash
      assert response_data["id"] == user_from_db.id
    end

    test ":login returns invalid password error when given invalid credentials", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :login), Map.replace!(@create_attrs, "password", @create_attrs["password"] <> "_"))
        |> json_response(422)

      assert response["error"] == Accounts.invalid_password_error()
    end
  end


  describe "when account doesn't exist" do
    test ":create creates user", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :create), @create_attrs)
        |> json_response(201)

      response_data = response["data"]

      query = from u in User, where: u.id == ^response_data["id"]
      user_from_db = Server.Repo.one!(query)

      assert response_data["id"] == user_from_db.id
      assert response_data["access_token"] == user_from_db.access_token
      assert response_data["email"] == user_from_db.email
      assert response_data["password_hash"] == user_from_db.password_hash
    end

    test ":login returns account doesn't exist error", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :login), @create_attrs)
        |> json_response(422)

      assert response["error"] == Accounts.account_does_not_exist_error()
    end

  end
end
