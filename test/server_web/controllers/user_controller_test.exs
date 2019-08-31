defmodule ServerWeb.UserControllerTest do
  use ServerWeb.ConnCase

  alias Server.Accounts
  alias Server.Accounts.User

  @email "shivangs44@gmail.com"
  @password "bubbles"


  # @create_attrs %{
  #   access_token: "some access_token",
  #   email: "some email",
  #   password_hash: "some password_hash"
  # }

  # @invalid_attrs %{access_token: nil, email: nil, password_hash: nil}

  # def fixture(:user) do
  #   {:ok, user} = Accounts.create_user(@create_attrs)
  #   user
  # end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # setup do
  #   Ecto.Adapters.SQL.Sandbox.allow(Server.Repo, self(), Accounts)
  # end

  defp create_user(context) do
    {:ok, %User{} = user} = Accounts.create_user(@email, @password)
    %{user: user}
  end

  describe "create user" do
    test "creates user when email is availabile", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :create), %{"email" => @email, "password" => @password})
        |> json_response(201)

      response_data = response["data"]

        assert response_data["id"]
        assert response_data["access_token"] == nil
        assert response_data["email"] == @email
        assert response_data["password_hash"]
    end

    test "returns error when email is unavailable", %{conn: conn, user: user} do
      {:ok, %User{} = user} = Accounts.create_user(@email, @password)

      response =
        conn
        |> post(Routes.user_path(conn, :create), %{"email" => @email, "password" => @password})
        |> json_response(201)

      assert response == "hi"

    end
  end

  # describe "create user" do
  #   test "renders user when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, Routes.user_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "access_token" => "some access_token",
  #              "email" => "some email",
  #              "password_hash" => "some password_hash"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update user" do
  #   setup [:create_user]

  #   test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
  #     conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.user_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "access_token" => "some updated access_token",
  #              "email" => "some updated email",
  #              "password_hash" => "some updated password_hash"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, user: user} do
  #     conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete user" do
  #   setup [:create_user]

  #   test "deletes chosen user", %{conn: conn, user: user} do
  #     conn = delete(conn, Routes.user_path(conn, :delete, user))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.user_path(conn, :show, user))
  #     end
  #   end
  # end

  # defp create_user(_) do
  #   user = fixture(:user)
  #   {:ok, user: user}
  # end
end
