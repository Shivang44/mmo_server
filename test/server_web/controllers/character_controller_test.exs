defmodule ServerWeb.CharacterControllerTest do
  use ServerWeb.ConnCase

  alias Server.Accounts
  alias Server.Accounts.Character
  alias Server.Accounts.User

  require IEx

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @user_create_attrs %{
    "email" => "shivangs44@gmail.com",
    "password" => "bubbles"
  }

  defp create_user(_context) do
    {:ok, %User{} = user} = Accounts.create_user(@user_create_attrs)
    {:ok, authed_user} = Accounts.authenticate(@user_create_attrs)
    %{user: authed_user}
  end

  defp authenticate(%{conn: conn, user: user}) do
    put_req_header(conn, "access_token", user.access_token)
    :ok
  end

  # describe "when a user has characters" do
  #   setup [:create_user, :authenticate]
  #   test ":index returns all characters for that user" do

  #   end
  # end

  describe "when a user doesn't have characters" do
    setup [:create_user, :authenticate]
    test ":index returns no characters" do
      conn = get(conn, Routes.user_character_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  # @create_attrs %{
  #   class: "some class",
  #   name: "some name",
  #   user_id: 42
  # }
  # @update_attrs %{
  #   class: "some updated class",
  #   name: "some updated name",
  #   user_id: 43
  # }
  # @invalid_attrs %{class: nil, name: nil, user_id: nil}

  # def fixture(:character) do
  #   {:ok, character} = Accounts.create_character(@create_attrs)
  #   character
  # end

  # setup %{conn: conn} do
  #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
  # end

  # describe "index" do
  #   test "lists all characters", %{conn: conn} do
  #     conn = get(conn, Routes.character_path(conn, :index))
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  # describe "create character" do
  #   test "renders character when data is valid", %{conn: conn} do
  #     conn = post(conn, Routes.character_path(conn, :create), character: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, Routes.character_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "class" => "some class",
  #              "name" => "some name",
  #              "user_id" => 42
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, Routes.character_path(conn, :create), character: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update character" do
  #   setup [:create_character]

  #   test "renders character when data is valid", %{conn: conn, character: %Character{id: id} = character} do
  #     conn = put(conn, Routes.character_path(conn, :update, character), character: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.character_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "class" => "some updated class",
  #              "name" => "some updated name",
  #              "user_id" => 43
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, character: character} do
  #     conn = put(conn, Routes.character_path(conn, :update, character), character: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete character" do
  #   setup [:create_character]

  #   test "deletes chosen character", %{conn: conn, character: character} do
  #     conn = delete(conn, Routes.character_path(conn, :delete, character))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.character_path(conn, :show, character))
  #     end
  #   end
  # end

  # defp create_character(_) do
  #   character = fixture(:character)
  #   {:ok, character: character}
  # end
end
