defmodule ServerWeb.CharacterController do
  use ServerWeb, :controller

  alias Server.Accounts
  alias Server.Accounts.Character

  action_fallback ServerWeb.FallbackController

  @spec index(Plug.Conn.t(), nil | keyword | map) :: Plug.Conn.t()
  def index(conn, params) do
    characters = params["user_id"] |> Accounts.list_characters()
    render(conn, "index.json", characters: characters)
  end

  @spec create(any, any) :: any
  def create(conn, params) do
    with {:ok, %Character{} = character} <- Accounts.create_character(params) do
      conn
      |> put_status(:created)
      |> render("show.json", character: character)
    end
  end

end
