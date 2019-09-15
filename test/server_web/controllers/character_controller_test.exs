defmodule ServerWeb.CharacterControllerTest do
  use ServerWeb.ConnCase, async: true

  alias Server.Accounts
  alias Server.Accounts.Character
  alias Server.Accounts.User

  require IEx

  setup %{conn: conn} do
    Ecto.Adapters.SQL.Sandbox.allow(Server.Repo, self(), Accounts)
    %{conn: put_req_header(conn, "accept", "application/json")}
  end

  @user_create_attrs %{
    "email" => "shivangs44@gmail.com",
    "password" => "bubbles"
  }

  defp create_user(_context) do
    {:ok, %User{} = _} = Accounts.create_user(@user_create_attrs)
    {:ok, authed_user} = Accounts.authenticate(@user_create_attrs)
    %{user: authed_user}
  end

  defp create_characters(%{user: user}) do
    {:ok, %Character{} = archer} = Accounts.create_character(%{
      "name" => "shivang",
      "class" => "archer",
      "user_id" => user.id
    })
    {:ok, %Character{} = warrior} = Accounts.create_character(%{
      "name" => "zhinkk",
      "class" => "warrior",
      "user_id" => user.id
    })
    {:ok, %Character{} = mage} = Accounts.create_character(%{
      "name" => "draucia",
      "class" => "mage",
      "user_id" => user.id
    })

    characters = Enum.map([archer, warrior, mage], fn char ->
      %{
        "id" => char.id,
        "name" => char.name,
        "class" => char.class,
        "user_id" => char.user_id
      }
    end)

    %{characters: characters}
  end


  defp authenticate(%{conn: conn, user: user}) do
    %{conn: put_req_header(conn, "access_token", user.access_token)}
  end


  describe "when a user doesn't have characters" do
    setup [:create_user, :authenticate]
    test ":index returns no characters when access_token is valid", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_character_path(conn, :index, user.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "when a user has characters" do
    setup [:create_user, :create_characters, :authenticate]
    test ":index returns all characters for that user", %{conn: conn, user: user, characters: expected_characters} do
      conn = get(conn, Routes.user_character_path(conn, :index, user.id))
      assert json_response(conn, 200)["data"] == expected_characters
    end
  end

  describe "when a character name is available" do
    setup [:create_user, :authenticate]
    test ":create creates a character", %{user: user, conn: conn} do
      create_attrs = %{
        "name" => "shivang",
        "class" => "mage",
        "user_id" => user.id
      }

      response =
        conn
        |> post(Routes.user_character_path(conn, :create, user.id), create_attrs)
        |> json_response(201)

      response_with_added_id = Map.put(create_attrs, "id", response["data"]["id"])
      assert response["data"] == response_with_added_id

    end
  end

  describe "when a character name is not available" do
    setup [:create_user, :create_characters, :authenticate]
    test ":create returns an error", %{user: user, characters: characters, conn: conn} do
      already_created_character = List.first(characters)
      response =
        conn
        |> post(Routes.user_character_path(conn, :create, user.id), already_created_character)
        |> json_response(422)

      assert response["error"] == Accounts.character_name_taken_error()
    end
  end

end
